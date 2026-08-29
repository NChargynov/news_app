import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:news_app/core/router/app_router.gr.dart';
import 'package:news_app/features/auth/presentation/auth_page.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      Platform.isIOS ? RouteType.cupertino() : RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: AuthRoute.page),
    AutoRoute(page: MainRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: NewsRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: EveryThingRoute.page),
    AutoRoute(page: NewsDetailRoute.page),
  ];
}
