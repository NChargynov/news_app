import 'package:news_app/features/auth/domain/repo/auth_repo.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.response);

  final Future<bool> Function() response;
  final calls = <(String, String)>[];

  @override
  Future<bool> auth(String login, String password) {
    calls.add((login, password));
    return response();
  }
}
