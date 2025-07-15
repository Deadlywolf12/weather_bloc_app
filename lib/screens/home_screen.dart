import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';
import 'package:weather_bloc_app/bloc/weather/weather_state.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/forecast_screen.dart';
import 'package:weather_bloc_app/screens/widgets/wind_direc_widget.dart';
import 'package:weather_bloc_app/services/get_greetings.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';
import 'package:weather_bloc_app/services/get_wind_direc.dart';
import 'package:weather_bloc_app/services/handle_bg.dart';
import 'package:weather_bloc_app/services/handle_location.dart';
import 'package:weather_bloc_app/services/handle_location_connectivity.dart';
import 'package:weather_bloc_app/services/handle_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLocationAndConnectivity(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ForecastBloc, ForecastState>(builder: (context, state) {
      if (state is ForecastLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is ForecastLoaded) {
        final forecastList = state.forecast.forecastList;
        final city = state.forecast.city.name;

        if (forecastList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No forecast data available"),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  onPressed: () => getCurrentLocationWeather(context),
                )
              ],
            ),
          );
        }

        final today = forecastList.first;
        final date = DateTime.now();
        final formattedDate = DateFormat('EEEE d - h:mm a').format(date);
        final greetings = getGreeting();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: () => refreshWeatherIfCacheExpired(context),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: false,
                  expandedHeight: 40,
                  backgroundColor: AppColors.background,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return FlexibleSpaceBar(
                        titlePadding: EdgeInsets.all(10.0),
                        centerTitle: false,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              greetings,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(Icons.settings,
                                size: screenWidth * 0.06,
                                color: AppColors.white),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Current Location",
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.05,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                city,
                                                style: TextStyle(
                                                    fontSize:
                                                        screenWidth * 0.05),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                              child: Icon(Icons.location_on,
                                  size: screenWidth * 0.07,
                                  color: AppColors.white),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(city,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.074,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white)),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Image.asset(
                          GetWeatherCondition(code: today.weather.first.id)
                              .getWeatherCondition(),
                          width: screenWidth * 0.4,
                        ),
                        Text(
                          "${today.main.temp.round()}°C",
                          style: TextStyle(
                              fontSize: screenWidth * 0.15,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(today.weather.first.main,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                        Text(
                            "Feels like ${today.main.feelsLike.toStringAsFixed(1)}°C",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300)),
                        SizedBox(height: screenHeight * 0.07),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.air, size: screenHeight * 0.055),
                            Column(
                              children: [
                                const Text("Wind Speed",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Text("${today.wind.speed} km/h",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            buildWindDirectionIcon(
                                today.wind.deg.toDouble(), context),
                            Column(
                              children: [
                                const Text("Wind Direction",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Text(getWindDirection(today.wind.deg.toInt()),
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        const Divider(
                          thickness: 2,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.thermostat_sharp,
                                color: Colors.red, size: screenHeight * 0.055),
                            Column(
                              children: [
                                const Text("Max Temp",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "${today.main.tempMax.toStringAsFixed(1)}°C",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Icon(Icons.thermostat_sharp,
                                color: Colors.lightBlue,
                                size: screenHeight * 0.055),
                            Column(
                              children: [
                                const Text("Min Temp",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "${today.main.tempMin.toStringAsFixed(1)}°C",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        const Divider(thickness: 2),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.water_drop_rounded,
                                size: screenHeight * 0.055),
                            Column(
                              children: [
                                const Text("Humidity",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Text("${today.main.humidity} %",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            Icon(Icons.wb_cloudy_rounded,
                                size: screenHeight * 0.055),
                            Column(
                              children: [
                                const Text("Clouds",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Text("${today.clouds.all} %",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        const Text("5 days Forecast",
                            style: TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForecastScreen(
                                forecast: forecastList,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_downward, size: 25),
                        ),
                        SizedBox(
                          height: 300,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      } else if (state is ForecastError) {
        return Center(child: Text('Error: ${state.message}'));
      }

      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    });
  }
}
