import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/features/news/data/remote/api/news_data_source.dart';
import 'package:news_app/features/news/data/remote/impl/news_data_source_impl.dart';
import 'package:news_app/features/news/data/repo_impl/news_repository_impl.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';
import 'package:news_app/features/news/ui/bloc/news_bloc.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton(TalkerFlutter.init());

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://newsapi.org/v2/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      TalkerDioLogger(
        talker: getIt<Talker>(),
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
  });

  getIt.registerLazySingleton<NewsDataSource>(
    () => NewsDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(dataSource: getIt<NewsDataSource>()),
  );

  getIt.registerFactory<NewsBloc>(
        () => NewsBloc(newsRepository: getIt<NewsRepository>()),
  );
}

