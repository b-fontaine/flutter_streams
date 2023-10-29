import 'package:injectable/injectable.dart';
import 'package:part_2/domain/domain_module.dart';

@singleton
class WeatherInteractor {
  final WeatherStreamUseCase _weatherStreamUseCase;
  late final Stream<List<String>> _stream;

  WeatherInteractor(
    @Named.from(WeatherStreamUseCase) this._weatherStreamUseCase,
  ) {
    _stream = _weatherStreamUseCase.stream.map((event) =>
        event.map((e) => "${e.city} : ${e.temperatureInCelsius} °C").toList());
  }

  Stream<List<String>> get stream => _stream;

  Future<List<String>> getWeathers() async {
    var result = await _weatherStreamUseCase.getWeatherData();
    return result
        .map((e) => "${e.city} : ${e.temperatureInCelsius} °C")
        .toList();
  }
}
