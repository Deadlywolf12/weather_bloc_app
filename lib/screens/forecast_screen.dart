import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_bloc_app/models/forecast_item.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class ForecastScreen extends StatelessWidget {
  final List<ForecastItem> forecast;

  const ForecastScreen({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    // Group forecast data by date
    final Map<String, List<ForecastItem>> groupedForecast = {};

    for (var item in forecast) {
      final dateTime = DateTime.parse(item.dtTxt);
      final dayKey = DateFormat('yyyy-MM-dd').format(dateTime);
      groupedForecast.putIfAbsent(dayKey, () => []).add(item);
    }

    final sortedKeys = groupedForecast.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor1,
        title: const Text("5-Day Forecast"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedKeys.length > 5 ? 5 : sortedKeys.length,
        itemBuilder: (context, index) {
          final dayKey = sortedKeys[index];
          final dailyWeatherList = groupedForecast[dayKey]!;

          final dayTitle = DateFormat('EEEE, MMM d')
              .format(DateTime.parse(dailyWeatherList.first.dtTxt));

          return Card(
            color: AppColors.primaryColor1.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              title: Text(dayTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              children: dailyWeatherList.map((weather) {
                final dateTime = DateTime.parse(weather.dtTxt);
                final time = DateFormat('h:mm a').format(dateTime);
                final temp = (weather.main.temp).toStringAsFixed(1);
                final desc = weather.weather.first.description;
                final icon = weather.weather.first.icon;

                return ListTile(
                  leading: Image.network(
                    'https://openweathermap.org/img/wn/$icon@2x.png',
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  title: Text("$time - $desc"),
                  trailing: Text(
                    "$temp°C",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
