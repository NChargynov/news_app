import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:news_app/core/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Page,Route")
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      Platform.isIOS ? RouteType.cupertino() : RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page, initial: true),
    AutoRoute(page: EverythingRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: MainRoute.page),
    AutoRoute(page: NewsDetailRoute.page),
    AutoRoute(page: ProfileRoute.page),
  ];
}
