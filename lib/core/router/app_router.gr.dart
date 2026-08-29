// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:news_app/features/auth/presentation/auth_page.dart' as _i1;
import 'package:news_app/features/home/presentation/home_page.dart' as _i3;
import 'package:news_app/features/main/presentation/main_page.dart' as _i4;
import 'package:news_app/features/news/domain/models/news_model_entity.dart'
    as _i11;
import 'package:news_app/features/news/presentation/everything_page.dart'
    as _i2;
import 'package:news_app/features/news/presentation/news_detail_page.dart'
    as _i5;
import 'package:news_app/features/news/presentation/news_page.dart' as _i6;
import 'package:news_app/features/profile/presentation/profile_page.dart'
    as _i7;
import 'package:news_app/features/splash/presentation/splash_page.dart' as _i8;

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i9.PageRouteInfo<void> {
  const AuthRoute({List<_i9.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthPage();
    },
  );
}

/// generated route for
/// [_i2.EveryThingPage]
class EveryThingRoute extends _i9.PageRouteInfo<void> {
  const EveryThingRoute({List<_i9.PageRouteInfo>? children})
    : super(EveryThingRoute.name, initialChildren: children);

  static const String name = 'EveryThingRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i2.EveryThingPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.MainPage]
class MainRoute extends _i9.PageRouteInfo<void> {
  const MainRoute({List<_i9.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i4.MainPage();
    },
  );
}

/// generated route for
/// [_i5.NewsDetailPage]
class NewsDetailRoute extends _i9.PageRouteInfo<NewsDetailRouteArgs> {
  NewsDetailRoute({
    _i10.Key? key,
    required _i11.NewsEntity article,
    List<_i9.PageRouteInfo>? children,
  }) : super(
         NewsDetailRoute.name,
         args: NewsDetailRouteArgs(key: key, article: article),
         initialChildren: children,
       );

  static const String name = 'NewsDetailRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewsDetailRouteArgs>();
      return _i5.NewsDetailPage(key: args.key, article: args.article);
    },
  );
}

class NewsDetailRouteArgs {
  const NewsDetailRouteArgs({this.key, required this.article});

  final _i10.Key? key;

  final _i11.NewsEntity article;

  @override
  String toString() {
    return 'NewsDetailRouteArgs{key: $key, article: $article}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NewsDetailRouteArgs) return false;
    return key == other.key && article == other.article;
  }

  @override
  int get hashCode => key.hashCode ^ article.hashCode;
}

/// generated route for
/// [_i6.NewsPage]
class NewsRoute extends _i9.PageRouteInfo<void> {
  const NewsRoute({List<_i9.PageRouteInfo>? children})
    : super(NewsRoute.name, initialChildren: children);

  static const String name = 'NewsRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.NewsPage();
    },
  );
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute({List<_i9.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.ProfilePage();
    },
  );
}

/// generated route for
/// [_i8.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute({List<_i9.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.SplashPage();
    },
  );
}
