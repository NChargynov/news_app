import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

@LazySingleton()
class PushForegroundService {
  PushForegroundService({
    required this.firebaseMessaging,
    required this.flutterLocalNotificationsPlugin,
    required this.talker,
  });

  final FirebaseMessaging firebaseMessaging;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final Talker talker;

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
        'body=${remoteMessage.notification?.body}',
      );

      _showLocalNotification(remoteMessage);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    final android = notification?.android;

    final title = notification?.title ?? "";
    final body = notification?.body ?? "";

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
}
