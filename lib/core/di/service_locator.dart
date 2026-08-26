import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'service_locator.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> setupServiceLocator() async => getIt.init();

@module
abstract class AppModule {
  @singleton
  FlutterSecureStorage get flutterSecureStorage => FlutterSecureStorage();

  @singleton
  Talker get talker => TalkerFlutter.init();

  @singleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @singleton
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      FlutterLocalNotificationsPlugin();

  @singleton
  Dio dio(Talker talker) {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://newsapi.org/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printRequestHeaders: false,
          printResponseData: true,
          printResponseMessage: true,
          printResponseHeaders: true,
          printResponseTime: true,
          hiddenHeaders: {'X-Api-Key'},
        ),
      ),
    );
    return dio;
  }
}

// Future<void> setupServiceLocator() async {

// getIt.registerSingleton<Talker>(TalkerFlutter.init());

// getIt.registerLazySingleton<Dio>(() {
//   final dio = Dio(
//     BaseOptions(
//       baseUrl: "https://newsapi.org/",
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   );
//
//   dio.interceptors.add(
//     TalkerDioLogger(
//       talker: getIt<Talker>(),
//       settings: const TalkerDioLoggerSettings(
//         printRequestData: true,
//         printRequestHeaders: false,
//         printResponseData: true,
//         printResponseMessage: true,
//         printResponseHeaders: true,
//         printResponseTime: true,
//         hiddenHeaders: {'X-Api-Key'},
//       ),
//     ),
//   );
//
//   return dio;
// });

// getIt.registerLazySingleton<NewsDataSource>(
//   () => NewsDataSourceImpl(dio: getIt<Dio>()),
// );
//
// getIt.registerLazySingleton<NewsRepository>(
//   () => NewsRepositoryImpl(dataSource: getIt<NewsDataSource>()),
// );

// getIt.registerLazySingleton<GetNewsUseCase>(
//   () => GetNewsUseCase(repository: getIt<NewsRepository>()),
// );

// getIt.registerFactory<NewsBloc>(
//       () => NewsBloc(getNews: getIt<GetNewsUseCase>()),
// );
// }
