import 'package:weather_bloc_app/services/get_greetings.dart';
import 'package:weather_bloc_app/services/get_weather_by_code.dart';

class GetWeatherCondition {
  final int code;

  GetWeatherCondition({required this.code});

  String get _weather => getWeatherCode(code);
  String get _time => getGreeting();

  String getWeatherCondition() {
    if (_time == "Good Morning!" || _time == "Good Afternoon!") {
      switch (_weather) {
        case "rainWThunderStorm":
          return "assets/day_rain_thunder.png";
        case "rain":
          return "assets/day_rain.png";
        case "snow":
          return "assets/day_snow.png";
        case "clouds":
          return "assets/day_partial_cloud.png";
        case "clear":
          return "assets/sun.png";
        default:
          return "assets/day_partial_cloud.png";
      }
    } else if (_time == "Good Evening!" || _time == "Good Night!") {
      switch (_weather) {
        case "rainWThunderStorm":
          return "assets/night_full_moon_rain_thunder.png";
        case "rain":
          return "assets/night_full_moon_rain.png";
        case "snow":
          return "assets/night_full_moon_snow.png";
        case "clouds":
          return "assets/NFMC.png";
        case "clear":
          return "assets/night_full_moon_clear.png";
        default:
          return "assets/night_full_moon_clear.png";
      }
    } else {
      return "assets/day_partial_cloud.png";
    }
  }
}
