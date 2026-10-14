import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

@LazySingleton()
class PushForegroundService {
  const PushForegroundService({
    required this.messaging,
    required this.localNotificationsPlugin,
    required this.talker,
  });

  final FirebaseMessaging messaging;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final Talker talker;


  static const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
        "news_app_push_channel",
        "News App Push Notifications",
        description: "System notifications for Firebase Cloud Messaging",
        importance: Importance.high,
      );

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await localNotificationsPlugin.initialize(settings: initializationSettings);

    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      talker.info(
        'Push message received. '
        'source=foreground, messageId=${remoteMessage.messageId}, '
        'title=${remoteMessage.notification?.title}, '
        'body=${remoteMessage.notification?.body}, ',
      );

      _showLocalNotification(remoteMessage);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage remoteMessage) async{

    // `notification` заполняется, когда FCM payload содержит notification-блок.
    final notification = remoteMessage.notification;

    // Android-specific часть notification нужна, например, чтобы взять smallIcon.
    final android = notification?.android;

    // Поддерживаем оба формата payload:
    // 1. notification title/body;
    final title = notification?.title;
    final body = notification?.body;

    // Если нечего показывать пользователю, только пишем лог и выходим.
    if (title == null && body == null) {
      talker.info('Push message has no notification title/body to display');
      return;
    }

    // Показываем системное уведомление через flutter_local_notifications.
    await localNotificationsPlugin.show(
      // id нужен Android/iOS для идентификации notification.
      // hashCode сообщения достаточно для простого demo-сценария.
      id: remoteMessage.hashCode,
      title: title ?? 'News App',
      body: body ?? '',
      notificationDetails: NotificationDetails(
        // Настройки Android-уведомления: канал, priority, importance, icon.
        android: AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: androidNotificationChannel.description,
          icon: android?.smallIcon,
          importance: Importance.high,
          priority: Priority.high,
        ),
        // Настройки iOS-уведомления: показать alert, badge и sound.
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: remoteMessage.messageId,
    );
  }
}
