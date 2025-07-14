import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';
import 'package:weather_bloc_app/bloc/weather/weather_event.dart';
import 'package:weather_bloc_app/screens/widgets/alert_box.dart';
import 'package:weather_bloc_app/services/check_connectivity.dart';
import 'package:weather_bloc_app/services/handle_location.dart';

void checkLocationAndConnectivity(BuildContext context) async {
  final connectivity = await checkConnectivity();

  final locationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!locationEnabled) {
    AlertBox(
        title: "Enable Location",
        content:
            "Please Enable your location to get RealTime Weather updates. ",
        btn1: "Cancel",
        btn2: "Enable",
        onBtn1Pressed: () {
          Navigator.of(context).pop();
        },
        onBtn2Pressed: () {
          getCurrentLocationWeather(context);
          Navigator.of(context).pop();
        }).showCustomAlertDialog(context);
    context.read<ForecastBloc>().add(FetchForecast(UseCacheOnly: true));
  } else if (connectivity) {
    getCurrentLocationWeather(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No internet connection available.")),
    );
    context.read<ForecastBloc>().add(FetchForecast(UseCacheOnly: true));
  }
}
