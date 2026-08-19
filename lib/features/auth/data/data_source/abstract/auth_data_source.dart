import 'package:news_app/features/news/data/models/news_model.dart';

abstract interface class AuthDataSource {
  Future<bool> auth(String login, String password);
}
