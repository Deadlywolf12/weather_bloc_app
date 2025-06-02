import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/forecast_screen.dart';

import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showForecastSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // For smooth rounded top
      barrierColor: Colors.black.withOpacity(0.4), // Dim background
      elevation: 0,
      builder: (context) => const ForecastContent(),
    );
  }

  void _getCurrentLocationWeather(BuildContext context) async {
    try {
      final position = await LocationService().determinePosition();
      final lat = position.latitude;
      final lon = position.longitude;

      // TODO: Dispatch a BLoC event or API call with lat/lon
      print("Lat: $lat, Lon: $lon");

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
    return Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Good Night!",
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.w600),
            ),
          ),
          leadingWidth: 200,
          actions: [
            GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text('Not Enabled'),
                  ],
                ),
              ),
            )
          ],
        ),
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -10) {
              // User swiped up
              _showForecastSheet(context);
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
                  filter: ImageFilter.blur(
                      sigmaX: 10, sigmaY: 10), // Adjust blur level
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // Optional tint
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsetsGeometry.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/NFMC.png",
                          height: 200,
                        ),
                      ),
                      const Center(
                        child: Text(
                          "20°C",
                          style: TextStyle(
                              fontSize: 80, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Clear - Cloudy",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Wednesday 16 - 10:00 Am",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/sun.png",
                                height: 45,
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "Sun Set",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "5:45 Am",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/night_full_moon_clear.png",
                                height: 45,
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "Sun Rise",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "5:45 Am",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: AppColors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/maxTemp.png",
                                height: 45,
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "Max Temp",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "45°C",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                "assets/minTemp.png",
                                height: 45,
                              ),
                              const Column(
                                children: [
                                  Text(
                                    "Min Temp",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "15°C",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "5 days Forecast",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                          onPressed: () {
                            _showForecastSheet(context);
                          },
                          icon: const Icon(
                            Icons.arrow_downward,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
