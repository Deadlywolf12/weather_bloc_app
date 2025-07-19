import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_bloc_app/models/forecast_item.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';

class ShowWeekwiseData {
  final List<ForecastItem> forecast;

  ShowWeekwiseData({required this.forecast});

  void showDayForecastDialog(BuildContext context, DateTime selectedDate) {
    final String targetDateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    // Filter only forecast items for the selected day
    final List<ForecastItem> dayForecast = forecast.where((item) {
      final itemDateKey =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(item.dtTxt));
      return itemDateKey == targetDateKey;
    }).toList();

    const tileHeight = 80.0;
    final dialogHeight =
        (dayForecast.length * tileHeight).clamp(200.0, height * 0.6);

    if (dayForecast.isEmpty) {
      // Handle if no data found
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('No Data'),
          content: const Text('No forecast available for this day.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: dialogHeight,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.tiles,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat('EEEE, MMM d').format(selectedDate),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: dayForecast.length,
                    itemBuilder: (context, index) {
                      final item = dayForecast[index];
                      final dateTime = DateTime.parse(item.dtTxt);
                      final time = DateFormat('h:mm a').format(dateTime);
                      final hour = dateTime.hour;

                      final temp = item.main.temp.toStringAsFixed(1);
                      final desc = item.weather.first.description;
                      final id = item.weather.first.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              GetWeatherCondition(code: id, time: hour)
                                  .getWeatherCondition(),
                              width: width * 0.08,
                            ),
                            SizedBox(width: width * 0.02),
                            Text(time),
                            SizedBox(width: width * 0.02),
                            Text('- $desc'),
                            Spacer(),
                            Text('$temp°C'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
