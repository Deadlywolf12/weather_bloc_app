import 'package:flutter/material.dart';
import 'package:weather_bloc_app/models/forecast_item.dart';

class HourlyData {
  final BuildContext context;
  HourlyData({required this.context});
  List<Map<String, dynamic>> getTodayHourlyData(
      List<ForecastItem> allForecasts) {
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(Duration(days: 1));

    List<Map<String, dynamic>> data = allForecasts
        .where((item) => DateTime.parse(item.dtTxt).day == today.day)
        .map((item) {
      final time =
          TimeOfDay.fromDateTime(DateTime.parse(item.dtTxt)).format(context);
      final hours = DateTime.parse(item.dtTxt).hour;

      return {
        "time": time,
        "iconPath": item.weather.first.icon,
        "temp": item.main.temp.round(),
        "id": item.weather.first.id,
        "hours": hours,
      };
    }).toList();

    List<Map<String, dynamic>> tmrHourlyData = allForecasts
        .where((item) => DateTime.parse(item.dtTxt).day == tomorrow.day)
        .map((item) {
      final time =
          TimeOfDay.fromDateTime(DateTime.parse(item.dtTxt)).format(context);
      final hours = DateTime.parse(item.dtTxt).hour;
      return {
        "time": time,
        "iconPath": item.weather.first.icon,
        "temp": item.main.temp.round(),
        "id": item.weather.first.id,
        "hours": hours,
      };
    }).toList();

    data.addAll(tmrHourlyData.take(2));
    return data;
  }
}
