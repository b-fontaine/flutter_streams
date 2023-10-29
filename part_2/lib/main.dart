import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'injection.dart';
import 'ui/ui_module.dart';

void main() {
  configureDependencies();
  runApp(MyApp());
}

@injectable
class MyApp extends StatelessWidget {
  final AppRouter _router = getIt<AppRouter>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router.goRouter,
    );
  }
}


