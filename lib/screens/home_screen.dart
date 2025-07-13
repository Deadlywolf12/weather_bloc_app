import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';
import 'package:weather_bloc_app/bloc/weather/weather_event.dart';
import 'package:weather_bloc_app/bloc/weather/weather_state.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/forecast_screen.dart';
import 'package:weather_bloc_app/services/get_greetings.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';
import '../services/location_service.dart';

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
      _getCurrentLocationWeather(context);
    });
  }

  void _getCurrentLocationWeather(BuildContext context) async {
    try {
      final position = await LocationService().determinePosition();
      final lat = position.latitude;
      final lon = position.longitude;

      context
          .read<ForecastBloc>()
          .add(FetchForecast(latitude: lat, longitude: lon));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lat: $lat, Lon: $lon")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ForecastLoaded) {
          final forecastList = state.forecast.forecastList;
          final city = state.forecast.city.name;

          if (forecastList.isEmpty) {
            return const Center(child: Text("No forecast data available"));
          }

          final today = forecastList.first;
          final date = DateTime.now();

          final formattedDate = DateFormat('EEEE d - h:mm a').format(date);

          final greetings = getGreeting();

          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: EdgeInsets.all(screenWidth * 0.025),
                child: Text(
                  greetings,
                  style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w600),
                ),
              ),
              leadingWidth: screenWidth * 0.6,
              actions: [
                GestureDetector(
                  onTap: () => _getCurrentLocationWeather(context),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        Text(city,
                            style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            body: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -10) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ForecastScreen(forecast: forecastList)),
                  );
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/nightClearBackground.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.black.withOpacity(0.2)),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          Center(
                            child: Image.asset(
                              GetWeatherCondition(code: today.weather.first.id)
                                  .getWeatherCondition(),
                              height: screenHeight * 0.25,
                            ),
                          ),
                          Center(
                            child: Text(
                              "${today.main.temp.round()}°C",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.15,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Center(
                            child: Text(today.weather.first.main,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ),
                          Center(
                            child: Text(
                                "Feels like ${today.main.feelsLike.toStringAsFixed(1)}°C",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                          ),
                          Center(
                            child: Text(formattedDate,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w300)),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset("assets/wind.png",
                                      height: screenHeight * 0.06),
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
                                  Image.asset("assets/humidity.png",
                                      height: screenHeight * 0.06),
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
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              const Divider(color: AppColors.white),
                              SizedBox(height: screenHeight * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset("assets/maxTemp.png",
                                      height: screenHeight * 0.06),
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
                                  Image.asset("assets/minTemp.png",
                                      height: screenHeight * 0.06),
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
                              )
                            ],
                          ),
                          const Spacer(),
                          const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text("5 days Forecast",
                                style: TextStyle(fontSize: 16)),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForecastScreen(
                                          forecast: forecastList,
                                        )),
                              ),
                              icon: const Icon(Icons.arrow_downward, size: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ForecastError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => _getCurrentLocationWeather(context),
              child: const Text(
                  "Your location is currently not accessible. Please enable location first."),
            ),
          ),
        );
      },
    );
  }
}
