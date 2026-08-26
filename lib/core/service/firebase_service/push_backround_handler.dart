import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:news_app/firebase_options.dart';
import 'package:talker_flutter/talker_flutter.dart';

@pragma("vm:entry-point")
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  final talker = TalkerFlutter.init();
  
  talker.info(
    'Push message received. '
        'source=background_handler, messageId=${message.messageId}, '
        'title=${message.notification?.title}, '
        'body=${message.notification?.body}',
  );
}