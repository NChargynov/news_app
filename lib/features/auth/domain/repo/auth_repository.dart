import 'package:news_app/features/news/domain/models/news_model_entity.dart';

abstract interface class AuthRepository {
  Future<bool> auth(String login, String password);
}
