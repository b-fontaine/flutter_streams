import 'package:flutter/material.dart';

class WeatherTemperatures extends StatelessWidget {
  final List<String>? temperatures;
  const WeatherTemperatures({super.key, this.temperatures});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: (temperatures ?? [])
          .map((e) => Text(e))
          .toList(),
    );
  }
}
