import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';
import 'package:weather_bloc_app/app.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await dotenv.load(fileName: "weather_api_key.env");
  final apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    BlocProvider(
      create: (_) => ForecastBloc(),
      child: WeatherApp(
        seenOnboarding: seenOnboarding,
      ),
    ),
  );
}
