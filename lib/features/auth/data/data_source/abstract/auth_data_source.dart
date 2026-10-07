abstract class AuthDataSource {
  Future<bool> auth(String login, String password);
}
