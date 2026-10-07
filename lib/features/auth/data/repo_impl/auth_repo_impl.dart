import 'package:injectable/injectable.dart';
import 'package:news_app/features/auth/data/data_source/abstract/auth_data_source.dart';
import 'package:news_app/features/auth/domain/repo/auth_repo.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});

  final AuthDataSource dataSource;

  @override
  Future<bool> auth(String login, String password) async {
    return await dataSource.auth(login, password);
  }
}
