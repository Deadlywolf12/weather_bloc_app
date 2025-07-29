import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_bloc_app/app.dart';
import 'package:weather_bloc_app/bloc/chat/chat_bloc.dart';
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

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ChatBloc>(create: (_) => ChatBloc()),
      BlocProvider(
        create: (_) => ForecastBloc(),
      )
    ],
    child: WeatherApp(
      seenOnboarding: seenOnboarding,
    ),
  ));
}
