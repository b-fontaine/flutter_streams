import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import 'injection.dart';

abstract class WeatherService {
  Future<WeatherData> fetchWeather(String city);
}

@named
@Injectable(as: WeatherService)
class WeatherServiceImpl implements WeatherService {
  @factoryMethod
  @override
  Future<WeatherData> fetchWeather(String city) async {
    // Logique pour récupérer les données météo
    return WeatherData(temperatureInCelsius: 0, city: '');
  }
}

class WeatherData {
  final String city;
  final int temperatureInCelsius;

  WeatherData({required this.city, required this.temperatureInCelsius});
}

abstract class WeatherStream {
  void cancel();

  Stream<List<WeatherData>> get stream;
}

@named
@LazySingleton(as: WeatherStream)
class WeatherStreamImpl implements WeatherStream {
  final WeatherService service;
  bool _cancellationToken = false;

  WeatherStreamImpl(@Named.from(WeatherService) this.service);

  @override
  Stream<List<WeatherData>> get stream => Rx.combineLatest2(
        getWeatherUpdates('Paris'),
        getWeatherUpdates('New York'),
        (weatherParis, weatherNewYork) => [
          weatherParis,
          weatherNewYork,
        ],
      );

  Stream<WeatherData> getWeatherUpdates(String city) async* {
    while (true) {
      await Future.delayed(const Duration(minutes: 1));
      final data = await service.fetchWeather(city);
      yield data;
    }
  }

  @override
  void cancel() {
    _cancellationToken = true;
  }
}

class WeatherExample extends StatefulWidget {
  const WeatherExample({
    super.key,
  });

  @override
  State<WeatherExample> createState() => _WeatherExampleState();
}

class _WeatherExampleState extends State<WeatherExample> {
  final WeatherStream weather = getIt<WeatherStream>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Votre Météo"),
      ),
      body: Center(
        child: StreamBuilder<List<WeatherData>>(
          stream: weather.stream,
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
                  .map((e) => Text("${e.city} : ${e.temperatureInCelsius} °C"))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
