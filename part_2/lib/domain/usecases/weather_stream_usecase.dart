import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/data_module.dart';
import '../entities/entities_module.dart';

@named
@singleton
class WeatherStreamUseCase {
  final WeatherRepository weatherRepository;

  WeatherStreamUseCase(@Named.from(WeatherRepository) this.weatherRepository);

  Stream<List<WeatherData>> get stream =>
      Rx.combineLatest2(
        getWeatherUpdates('Paris'),
        getWeatherUpdates('New York'),
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