abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final List<String> weathers;
  WeatherLoaded(this.weathers);
}

class WeatherError extends WeatherState {
  final String errorMessage;

  WeatherError(this.errorMessage);
}