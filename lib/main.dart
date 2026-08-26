import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/core/service/firebase_service/push_foreground_service.dart';
import 'package:news_app/core/service/storage_service/secure_storage_service.dart';
import 'package:news_app/features/auth/presentation/auth_page.dart';
import 'package:news_app/features/main/presentation/main_page.dart';
import 'package:news_app/firebase_options.dart';

import 'core/service/firebase_service/push_backround_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await setupServiceLocator();

  await getIt<PushForegroundService>().initialize();

  final isAuthorized = await _isUserAuthorized();

  runApp(NewsApp(isAuthorized: isAuthorized));
}

Future<bool> _isUserAuthorized() async {
  try {
    final accessToken = await getIt<SecureStorageService>().get(
      SecureStorageKeys.accessTokenKey,
    );
    return accessToken?.trim().isNotEmpty ?? false;
  } catch (_) {
    return false;
  }
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key, required this.isAuthorized});

  final bool isAuthorized;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isAuthorized ? const MainPage() : const AuthPage(),
    );
  }
}
