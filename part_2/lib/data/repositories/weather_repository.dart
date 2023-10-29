import 'dart:math';

import 'package:injectable/injectable.dart';

import '../dto/weather_dto.dart';

@named
@injectable
class WeatherRepository {

  @factoryMethod
  Future<WeatherDto> fetchWeather(String city) async {
    await Future.delayed(const Duration(seconds: 1));
    // Logique pour récupérer les données météo
    return WeatherDto(temperatureInCelsius: Random().nextInt(60), city: city);
  }
}