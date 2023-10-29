import 'package:injectable/injectable.dart';
import 'package:part_2/domain/domain_module.dart';

@singleton
class WeatherCleanInteractor {
  final WeatherStreamUseCase weatherStreamUseCase;
  late final Stream<List<String>> _stream;

  WeatherCleanInteractor(
    @Named.from(WeatherStreamUseCase) this.weatherStreamUseCase,
  ) {
    _stream = weatherStreamUseCase.stream.map((event) =>
        event.map((e) => "${e.city} : ${e.temperatureInCelsius} °C").toList());
  }

  Stream<List<String>> get stream => _stream;
}
