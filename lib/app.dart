import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/on_boarding_screen.dart';
import 'screens/home_screen.dart';

class WeatherApp extends StatelessWidget {
  final bool seenOnboarding;

  const WeatherApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: seenOnboarding ? const HomeScreen() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
