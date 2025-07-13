import 'package:weather_bloc_app/models/city_data.dart';
import 'package:weather_bloc_app/models/clouds_data.dart';
import 'package:weather_bloc_app/models/main_data.dart';
import 'package:weather_bloc_app/models/rain_data.dart';
import 'package:weather_bloc_app/models/sys_data.dart';
import 'package:weather_bloc_app/models/weather_data.dart';
import 'package:weather_bloc_app/models/wind_data.dart';

class ForecastItem {
  final int dt;
  final MainData main;
  final List<WeatherData> weather;
  final Clouds clouds;
  final Wind wind;
  final int visibility;
  final double pop;
  final Rain? rain;
  final Sys sys;
  final String dtTxt;

  ForecastItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.visibility,
    required this.pop,
    required this.rain,
    required this.sys,
    required this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'],
      main: MainData.fromJson(json['main']),
      weather: List<WeatherData>.from(
          json['weather'].map((x) => WeatherData.fromJson(x))),
      clouds: Clouds.fromJson(json['clouds']),
      wind: Wind.fromJson(json['wind']),
      visibility: json['visibility'],
      pop: (json['pop'] as num).toDouble(),
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
      sys: Sys.fromJson(json['sys']),
      dtTxt: json['dt_txt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'dt': dt,
        'main': main.toJson(),
        'weather': weather.map((x) => x.toJson()).toList(),
        'clouds': clouds.toJson(),
        'wind': wind.toJson(),
        'visibility': visibility,
        'pop': pop,
        'rain': rain?.toJson(),
        'sys': sys.toJson(),
        'dt_txt': dtTxt,
      };
}
