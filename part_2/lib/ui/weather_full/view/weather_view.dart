import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../weather_bloc.dart';
import '../weather_event.dart';
import '../weather_state.dart';
import 'components/weather_error.dart';
import 'components/weather_temperatures.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherInitial) {
        context.read<WeatherBloc>().add(WeatherStarted());
        return const CircularProgressIndicator();
      }
      if (state is WeatherLoaded) {
        return WeatherTemperatures(temperatures: state.weathers);
      }
      if (state is WeatherError) {
        return WeatherOnError(errorMessage: state.errorMessage);
      }
      return const WeatherOnError(errorMessage: "Une erreur est survenue");
    });
  }
}
