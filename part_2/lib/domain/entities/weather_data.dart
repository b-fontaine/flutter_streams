import 'package:part_2/data/data_module.dart';

class WeatherData {
  final String city;
  final int temperatureInCelsius;

  WeatherData({required this.city, required this.temperatureInCelsius});

  factory WeatherData.fromDto(WeatherDto dto) => WeatherData(
        city: dto.city,
        temperatureInCelsius: dto.temperatureInCelsius,
      );
}
