import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'common/common_module.dart';
import 'weather_clean/weather_clean.dart';
import 'weather_full/view/weather_page.dart';

@singleton
class AppRouter {
  late final GoRouter goRouter;

  AppRouter() {
    goRouter = GoRouter(
      routes: <RouteBase>[
        GoRoute(
            path: '/',
            redirect: (BuildContext context, GoRouterState state) =>
            '/bloc'
        ),
        GoRoute(
          path: '/clean',
          builder: (BuildContext context, GoRouterState state) =>
          const MainScaffold(child: WeatherClean()),
        ),
        GoRoute(
          path: '/bloc',
          builder: (BuildContext context, GoRouterState state) =>
          const MainScaffold(child: WeatherPage()),
        ),
      ],
    );
  }
}