import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';
import 'package:weather_bloc_app/services/today_low_high_temp.dart';

class HourlyForecastSlider extends StatelessWidget {
  final List<Map<String, dynamic>> hourlyData;
  final String weatherDes;

  const HourlyForecastSlider(
      {super.key, required this.hourlyData, required this.weatherDes});

  @override
  Widget build(BuildContext context) {
    final high = getHighTemp(hourlyData);
    final low = getLowTemp(hourlyData);
    return Container(
      height: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppColors.gradColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("$weatherDes , High $high°C, Low $low°C.",
                style: const TextStyle(
                    color: AppColors.tiles,
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
          const Divider(
            color: AppColors.tiles,
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyData.length,
              itemBuilder: (context, index) {
                final data = hourlyData[index];

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 75,
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.tiles,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['time'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        GetWeatherCondition(
                                code: data['id'], time: data['hours'])
                            .getWeatherCondition(),
                        width: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${data['temp']}°C",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
