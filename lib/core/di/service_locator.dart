import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/core/di/service_locator.config.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> setupServiceLocator() async => getIt.init();

@module
abstract class AppModule {

  @singleton
  Talker get talker => TalkerFlutter.init();

  @singleton
  FlutterSecureStorage get flutterSecureStorage => FlutterSecureStorage();

  @singleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://newsapi.org/v2/",
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
//   getIt.registerSingleton(TalkerFlutter.init());
//
//   getIt.registerLazySingleton<Dio>(() {
//     final dio = Dio(
//       BaseOptions(
//         baseUrl: "https://newsapi.org/v2/",
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 10),
//       ),
//     );
//
//     dio.interceptors.add(
//       TalkerDioLogger(
//         talker: getIt<Talker>(),
//         settings: const TalkerDioLoggerSettings(
//           printRequestData: true,
//           printRequestHeaders: false,
//           printResponseData: true,
//           printResponseMessage: true,
//           printResponseHeaders: true,
//           printResponseTime: true,
//           hiddenHeaders: {'X-Api-Key'},
//         ),
//       ),
//     );
//     return dio;
//   });
//
//   getIt.registerLazySingleton<NewsDataSource>(
//     () => NewsDataSourceImpl(dio: getIt<Dio>()),
//   );
//
//   getIt.registerLazySingleton<NewsRepository>(
//     () => NewsRepositoryImpl(dataSource: getIt<NewsDataSource>()),
//   );
//
//   getIt.registerFactory<NewsBloc>(
//         () => NewsBloc(newsRepository: getIt<NewsRepository>()),
//   );
// }
