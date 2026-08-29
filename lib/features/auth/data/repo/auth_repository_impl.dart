import 'package:injectable/injectable.dart';
import 'package:news_app/core/util/transformable.dart';
import 'package:news_app/features/auth/data/data_source/abstract/auth_data_source.dart';
import 'package:news_app/features/auth/domain/repo/auth_repository.dart';
import 'package:news_app/features/news/data/data_source/abstract/news_data_source.dart';
import 'package:news_app/features/news/domain/models/news_model_entity.dart';
import 'package:news_app/features/news/domain/repository/news_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});

  final AuthDataSource dataSource;

  @override
  Future<bool> auth(String login, String password) async {
    return await dataSource.auth(login, password);
  }

  @override
  Future<bool> isAuthorized() async {
    return await dataSource.isAuthorized();
  }
}
