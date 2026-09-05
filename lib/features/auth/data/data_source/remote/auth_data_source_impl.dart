import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/core/service/storage_service/secure_storage_service.dart';
import 'package:news_app/features/auth/data/data_source/abstract/auth_data_source.dart';
import 'package:news_app/features/news/data/data_source/abstract/news_data_source.dart';
import 'package:news_app/features/news/data/models/news_model.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

final class _ApiPath {
  static const String auth = '/auth';
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl(this.secureStorageService, {required this.talker});

  final SecureStorageService secureStorageService;
  final Talker talker;

  @override
  Future<bool> auth(String login, String password) async {
    return true;

    final dio = Dio(
      BaseOptions(baseUrl: "https://test-ibragim.free.beeceptor.com"),
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

    final response = await dio.post(
      _ApiPath.auth,
      data: {"login": login, "password": password},
    );

    if (response.statusCode == 200 && response.data != null) {
      final accessToken = response.data["access_token"];
      final refreshToken = response.data["refresh_token"];

      await secureStorageService.save(
        SecureStorageKeys.accessTokenKey,
        accessToken,
      );

      await secureStorageService.save(
        SecureStorageKeys.refreshTokenKey,
        refreshToken,
      );

      return true;
    }

    return true;
  }

  @override
  Future<bool> isAuthorized() async {
    final accessToken = await secureStorageService.get(
      SecureStorageKeys.accessTokenKey,
    );
    return accessToken != null && accessToken.isNotEmpty;
  }
}
