import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';
import 'package:weather_bloc_app/services/today_low_high_temp.dart';

class WeeklyForecastWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final String weatherDes;

  const WeeklyForecastWidget(
      {super.key, required this.weeklyData, required this.weatherDes});

  @override
  Widget build(BuildContext context) {
    final high = getHighTemp(weeklyData);
    final low = getLowTemp(weeklyData);
    return Container(
      height: 400,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: AppColors.gradColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text("Weekly: Lowest 20 ,Higest 42°C",
                style: const TextStyle(
                    color: AppColors.tiles,
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
          const Divider(
            color: AppColors.tiles,
          ),
          SizedBox(
            height: 340,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 5.0),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                final data = weeklyData[index];

                return Card(
                  elevation: 3,
                  color: AppColors.tiles,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Thu",
                          style: TextStyle(color: AppColors.white),
                        ),
                        Image.asset(
                          "assets/day_partial_cloud.png",
                          width: 35,
                        ),
                        Image.asset(
                          "assets/night_full_moon_clear.png",
                          width: 35,
                        ),
                        const Text(
                          "36°C",
                          style: TextStyle(color: AppColors.white),
                        ),
                        const Text(
                          "26°C",
                          style: TextStyle(color: AppColors.white),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.play_arrow_sharp,
                      color: AppColors.white,
                    ),
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
