import 'package:flutter/material.dart';

import 'package:weather_bloc_app/models/forecast_item.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

import 'package:weather_bloc_app/screens/widgets/show_weekwise_data.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';

class WeeklyForecastWidget extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyData;
  final List<ForecastItem> forecast;

  const WeeklyForecastWidget(
      {super.key, required this.weeklyData, required this.forecast});

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "This Week’s Temperature Range",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(
            color: AppColors.tiles,
            thickness: 2,
          ),
          SizedBox(
            height: 340,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4.0),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (context, index) {
                final data = weeklyData[index];

                return GestureDetector(
                  onTap: () {
                    ShowWeekwiseData(forecast: forecast)
                        .showDayForecastDialog(context, data['date']);
                  },
                  child: Card(
                    elevation: 3,
                    color: AppColors.tiles,
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data["day"],
                            style: const TextStyle(color: AppColors.white),
                          ),
                          Image.asset(
                            GetWeatherCondition(code: data['dayId'], time: 6)
                                .getWeatherCondition(),
                            width: 35,
                          ),
                          Image.asset(
                            GetWeatherCondition(code: data['nightId'], time: 24)
                                .getWeatherCondition(),
                            width: 35,
                          ),
                          Text(
                            "${data['maxTemp']}°C",
                            style: const TextStyle(color: AppColors.white),
                          ),
                          Text(
                            "${data['minTemp']}°C",
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.play_arrow_sharp,
                        color: AppColors.white,
                      ),
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
