import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc_app/app.dart';

Future<void> main() async {
  await dotenv.load(fileName: "weather_api_key.env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Optional: transparent status bar
      statusBarIconBrightness: Brightness.light, // 👈 Light icons/text
      statusBarBrightness: Brightness.dark, // For iOS
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(WeatherApp(seenOnboarding: seenOnboarding));
}
