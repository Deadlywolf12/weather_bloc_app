import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';
import 'package:weather_bloc_app/bloc/weather/weather_event.dart';
import 'package:weather_bloc_app/services/location_service.dart';

void getCurrentLocationWeather(BuildContext context) async {
  try {
    final position = await LocationService().determinePosition();
    final lat = position.latitude;
    final lon = position.longitude;

    context
        .read<ForecastBloc>()
        .add(FetchForecast(latitude: lat, longitude: lon));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
