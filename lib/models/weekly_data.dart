import 'package:intl/intl.dart';
import 'package:weather_bloc_app/models/forecast_item.dart';

List<Map<String, dynamic>> getWeeklyData(List<ForecastItem> allForecasts) {
  final Map<String, List<ForecastItem>> groupedForecast = {};

  for (var item in allForecasts) {
    final dateTime = DateTime.parse(item.dtTxt);
    final dayKey = DateFormat('yyyy-MM-dd').format(dateTime);
    groupedForecast.putIfAbsent(dayKey, () => []).add(item);
  }

  final List<String> sortedKeys = groupedForecast.keys.toList()..sort();
  final List<Map<String, dynamic>> weeklyData = [];

  for (var key in sortedKeys.take(5)) {
    final items = groupedForecast[key]!;

    double minTemp = items.first.main.temp;
    double maxTemp = items.first.main.temp;

    int? dayWeatherId;
    int? nightWeatherId;

    Duration closestToDay = const Duration(days: 1); // far initial
    Duration closestToNight = const Duration(days: 1);

    for (var item in items) {
      final dateTime = DateTime.parse(item.dtTxt);
      final hour = dateTime.hour;
      final temp = item.main.temp;

      // min/max temp logic (optional if needed)
      if (temp < minTemp) minTemp = temp;
      if (temp > maxTemp) maxTemp = temp;

      final dayDiff = (dateTime.difference(
              DateTime(dateTime.year, dateTime.month, dateTime.day, 12)))
          .abs();
      if (dayDiff < closestToDay) {
        closestToDay = dayDiff;
        dayWeatherId = item.weather.first.id;
      }

      final nightDiff = (dateTime.difference(
              DateTime(dateTime.year, dateTime.month, dateTime.day, 3)))
          .abs();
      if (nightDiff < closestToNight) {
        closestToNight = nightDiff;
        nightWeatherId = item.weather.first.id;
      }
    }

    weeklyData.add({
      "day": DateFormat('E').format(DateTime.parse(items.first.dtTxt)),
      'date': DateTime.parse(items.first.dtTxt),
      "minTemp": minTemp.round(),
      "maxTemp": maxTemp.round(),
      "dayId": dayWeatherId,
      "nightId": nightWeatherId,
    });
  }

  return weeklyData;
}
