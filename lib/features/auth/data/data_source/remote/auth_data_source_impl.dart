import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/core/service/secure_storage_service.dart';
import 'package:news_app/features/auth/data/data_source/abstract/auth_data_source.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:talker_flutter/talker_flutter.dart';

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  const AuthDataSourceImpl(this.talker, this.secureStorageService);

  final Talker talker;
  final SecureStorageService secureStorageService;

  @override
  Future<bool> auth(String login, String password) async {
    final dio = Dio(BaseOptions(baseUrl: "https://geeks.free.beeceptor.com"));

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
      "/auth",
      data: {"login": login, "password": password},
    );

    if (response.statusCode == 200 && response.data != null) {
      final accessToken = response.data["access_token"];
      final refreshToken = response.data["refresh_token"];


      await secureStorageService.save("accessToken", accessToken);
      await secureStorageService.save("refreshToken", refreshToken);

      print("shamal accessToken  ${accessToken}");
      print("shamal refreshToken  ${refreshToken}");
      return true;
    }
    return false;
  }
}
