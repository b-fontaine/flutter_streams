import 'package:flutter/material.dart';

class WeatherOnError extends StatelessWidget {
  final String errorMessage;

  const WeatherOnError({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style:
          Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
    );
  }
}
