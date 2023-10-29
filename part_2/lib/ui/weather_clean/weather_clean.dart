import 'package:flutter/material.dart';
import 'package:part_2/injection.dart';

import 'weather_interactor.dart';

class WeatherClean extends StatefulWidget {
  const WeatherClean({super.key});

  @override
  State<WeatherClean> createState() => _WeatherCleanState();
}

class _WeatherCleanState extends State<WeatherClean> {
  final WeatherCleanInteractor _weatherCleanInteractor =
      getIt<WeatherCleanInteractor>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: _weatherCleanInteractor.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: (snapshot.data ?? [])
              .map((e) => Text(e))
              .toList(),
        );
      },
    );
  }
}
