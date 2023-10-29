import 'dart:math';

import 'package:flutter/material.dart';

Stream<WeatherData> getWeatherUpdates() async* {
  while (true) {
    // Mettre à jour toutes les minutes
    await Future.delayed(const Duration(minutes: 1));
    final data = await fetchWeatherDataFromAPI();
    yield data;
  }
}

class WeatherData {
  final int temperatureInCelsius;

  WeatherData({required this.temperatureInCelsius});
}

Future<WeatherData> fetchWeatherDataFromAPI() async {
  await Future.delayed(const Duration(seconds: 1));
  // Pour éviter d'avoir à chercher une API, on renvoie une valeur random
  return WeatherData(temperatureInCelsius: Random().nextInt(100));
}

class MinimalExample extends StatefulWidget {
  const MinimalExample({super.key, required this.title});

  final String title;

  @override
  State<MinimalExample> createState() => _MinimalExampleState();
}

class _MinimalExampleState extends State<MinimalExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Votre météo',
            ),
            StreamBuilder<WeatherData>(
              stream: getWeatherUpdates(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Erreur : ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Text(
                    'Température : ${snapshot.data?.temperatureInCelsius}°C');
              },
            ),
          ],
        ),
      ),
    );
  }
}
