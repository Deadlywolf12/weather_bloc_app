import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';
import 'package:weather_bloc_app/screens/on_boarding_screen.dart';
import 'screens/home_screen.dart';

class WeatherApp extends StatelessWidget {
  final bool seenOnboarding;

  const WeatherApp({
    super.key,
    required this.seenOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForecastBloc(),
      child: MaterialApp(
        title: 'Weather App',
        home: seenOnboarding ? HomeScreen() : OnboardingScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      ),
    );
  }
}
