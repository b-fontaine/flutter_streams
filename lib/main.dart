import 'package:flutter/material.dart';
import 'package:flutter_streams/dependencies_injection.dart';
import 'package:go_router/go_router.dart';

import 'injection.dart';
import 'minimal.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        redirect: (BuildContext context, GoRouterState state) =>
        '/minimal'
    ),
    GoRoute(
      path: '/minimal',
      builder: (BuildContext context, GoRouterState state) =>
      const MinimalExample(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      path: '/injection',
      builder: (BuildContext context, GoRouterState state) =>
      const WeatherExample(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

