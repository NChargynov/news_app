import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news_app/core/di/service_locator.dart';
import 'package:news_app/core/service/firebase_service/push_foreground_service.dart';
import 'package:news_app/features/news/domain/repo/news_repository.dart';
import 'package:news_app/features/news/ui/bloc/news_event.dart';
import 'package:news_app/features/news/ui/bloc/news_state.dart';
import 'package:talker_flutter/talker_flutter.dart';

@injectable
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({required this.newsRepository}) : super(NewsInitial()) {
    on<GetEverythingEvent>(_getEverythingArticles);
    on<RequestPermissionEvent>(_requestPermissionEvent);
  }

  final NewsRepository newsRepository;

  FutureOr<void> _getEverythingArticles(
    GetEverythingEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final result = await newsRepository.getEverythingArticles();
      emit(NewsSuccess(news: result));
    } catch (error) {
      emit(NewsFailure("Новостей нет"));
    }
  }

  FutureOr<void> _requestPermissionEvent(
    RequestPermissionEvent event,
    Emitter<NewsState> emit,
  ) async {
    final FirebaseMessaging firebaseMessaging = getIt<FirebaseMessaging>();
    final fcmToken = await firebaseMessaging.getToken();
    final talker = getIt<Talker>();
    talker.info('Current FCM token: $fcmToken');

    final currentSettings = await firebaseMessaging.getNotificationSettings();

    if (_isAuthorizedPermission(currentSettings.authorizationStatus)) {
      talker.info(
        'Notification permission already granted: '
        '${currentSettings.authorizationStatus.name}',
      );
    } else {
      final requestedSettings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final granted = _isAuthorizedPermission(
        requestedSettings.authorizationStatus,
      );
      if (granted) {
        talker.info(
          'Notification permission request result: '
          '${requestedSettings.authorizationStatus.name}',
        );
      }

      final PushForegroundService pushForegroundService =
          getIt<PushForegroundService>();
      pushForegroundService.initialize();
    }
  }

  bool _isAuthorizedPermission(AuthorizationStatus status) {
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }
}
