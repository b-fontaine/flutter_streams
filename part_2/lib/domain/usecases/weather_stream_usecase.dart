import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/data_module.dart';
import '../entities/entities_module.dart';

@named
@singleton
class WeatherStreamUseCase {
  final WeatherRepository weatherRepository;
  static const String VILLE_1 = 'Paris';
  static const String VILLE_2 = 'New York';

  WeatherStreamUseCase(@Named.from(WeatherRepository) this.weatherRepository);

  Future<List<WeatherData>> getWeatherData() async =>
      [
        WeatherData.fromDto(await weatherRepository.fetchWeather(VILLE_1)),
        WeatherData.fromDto(await weatherRepository.fetchWeather(VILLE_2)),
      ];

  Stream<List<WeatherData>> get stream =>
      Rx.combineLatest2(
        getWeatherUpdates(VILLE_1),
        getWeatherUpdates(VILLE_2),
            (weatherParis, weatherNewYork) =>
        [
          weatherParis,
          weatherNewYork,
        ],
      );

  Stream<WeatherData> getWeatherUpdates(String city) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 15));
      final data = await weatherRepository.fetchWeather(city);
      yield WeatherData.fromDto(data);
    }
  }
}