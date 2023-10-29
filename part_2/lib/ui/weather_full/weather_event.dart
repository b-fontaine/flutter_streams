abstract class WeatherEvent {}

class WeatherStarted extends WeatherEvent {}

class ErrorWeather extends WeatherEvent {
  final String errorMessage;

  ErrorWeather(this.errorMessage);
}

class FetchedWeather extends WeatherEvent {
  final List<String> weathers;
  FetchedWeather(this.weathers);
}