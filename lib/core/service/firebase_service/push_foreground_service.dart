import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

@LazySingleton()
class PushForegroundService {
  PushForegroundService({
    required this.dio,
    required this.firebaseMessaging,
    required this.flutterLocalNotificationsPlugin,
    required this.talker,
  });

  final Dio dio;
  final FirebaseMessaging firebaseMessaging;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Talker talker;

  static const int _maxImageSizeInBytes = 1024 * 1024;

  static const AndroidNotificationChannel _androidNotificationChannel =
      AndroidNotificationChannel(
        'news_app_push_channel',
        'News App Push Notifications',
        description: 'System notifications for Firebase Cloud Messaging.',
        importance: Importance.high,
      );

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidNotificationChannel);

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      talker.info(
        'Push message received. '
        'source=foreground, messageId=${remoteMessage.messageId}, '
        'title=${remoteMessage.notification?.title}, '
        'body=${remoteMessage.notification?.body}, '
        'imageUrl=${remoteMessage.notification?.android?.imageUrl}',
      );

      _showLocalNotification(remoteMessage);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    final android = notification?.android;

    final title = notification?.title ?? "";
    final body = notification?.body ?? "";
    final image = await _loadAndroidImage(android?.imageUrl);

    if (title.isEmpty && body.isEmpty) {
      return;
    }

    await flutterLocalNotificationsPlugin.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidNotificationChannel.id,
          _androidNotificationChannel.name,
          channelDescription: _androidNotificationChannel.description,
          icon: android?.smallIcon,
          importance: Importance.high,
          priority: Priority.high,
          largeIcon: image,
          styleInformation: image == null
              ? null
              : BigPictureStyleInformation(
                  image,
                  contentTitle: title,
                  summaryText: body.isEmpty ? null : body,
                  hideExpandedLargeIcon: true,
                ),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.messageId,
    );
  }

  Future<ByteArrayAndroidBitmap?> _loadAndroidImage(String? imageUrl) async {
    final normalizedUrl = imageUrl?.trim();
    if (normalizedUrl == null || normalizedUrl.isEmpty) {
      return null;
    }

    try {
      final response = await dio.get<List<int>>(
        normalizedUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;

      if (bytes == null || bytes.isEmpty) {
        talker.warning('Push notification image is empty: $normalizedUrl');
        return null;
      }

      if (bytes.length > _maxImageSizeInBytes) {
        talker.warning('Push notification image exceeds 1 MB: $normalizedUrl');
        return null;
      }

      return ByteArrayAndroidBitmap(Uint8List.fromList(bytes));
    } catch (error, stackTrace) {
      talker.handle(
        error,
        stackTrace,
        'Failed to load push notification image: $normalizedUrl',
      );
      return null;
    }
  }
}
