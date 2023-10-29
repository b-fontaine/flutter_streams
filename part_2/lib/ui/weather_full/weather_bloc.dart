import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:part_2/injection.dart';

import 'weather_event.dart';
import 'weather_interactor.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  late final WeatherInteractor _interactor;
  StreamSubscription<List<String>>? _subscription;

  WeatherBloc() : super(WeatherInitial()) {
    _interactor = getIt<WeatherInteractor>();
    on<WeatherStarted>(_weatherStarted);
    on<FetchedWeather>(_fetchedWeather);
    on<ErrorWeather>(_errorWeather);
  }

  FutureOr<void> _weatherStarted(
      WeatherStarted event, Emitter<WeatherState> emit) async {
    add(FetchedWeather(await _interactor.getWeathers()));
    _subscription = _interactor.stream.listen(
      (event) {
        add(FetchedWeather(event));
      },
        onError: (error, _) {
          add(ErrorWeather("Une erreur est survenue"));
        }
    );
  }

  FutureOr<void> _fetchedWeather(
      FetchedWeather event, Emitter<WeatherState> emit) {
    emit(WeatherLoaded(event.weathers));
  }

  FutureOr<void> _errorWeather(ErrorWeather event, Emitter<WeatherState> emit) {
    emit(WeatherError(event.errorMessage));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
