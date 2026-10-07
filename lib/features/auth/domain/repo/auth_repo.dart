abstract interface class AuthRepository {
  Future<bool> auth(String login, String password);
}
