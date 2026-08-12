import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/features/news/data/data_source/abstract/news_data_source.dart';
import 'package:news_app/features/news/data/data_source/remote/news_data_source_impl.dart';
import 'package:news_app/features/news/data/repository/news_repository_impl.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';
import 'package:news_app/features/news/domain/use_case/get_news_use_case.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<Talker>(TalkerFlutter.init());

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://newsapi.org/",
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

  getIt.registerLazySingleton<GetNewsUseCase>(
    () => GetNewsUseCase(repository: getIt<NewsRepository>()),
  );

  getIt.registerFactory<NewsBloc>(
        () => NewsBloc(getNews: getIt<GetNewsUseCase>()),
  );
}
