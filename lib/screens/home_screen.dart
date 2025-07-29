import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_bloc_app/bloc/chat/chat_bloc.dart';
import 'package:weather_bloc_app/bloc/chat/chat_event.dart';
import 'package:weather_bloc_app/bloc/weather/weather_bloc.dart';
import 'package:weather_bloc_app/bloc/weather/weather_state.dart';
import 'package:weather_bloc_app/models/box1_data_map.dart';
import 'package:weather_bloc_app/models/chat_message_model.dart';
import 'package:weather_bloc_app/models/forecast_item.dart';
import 'package:weather_bloc_app/models/hourly_data.dart';
import 'package:weather_bloc_app/models/weekly_data.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/widgets/chat_launcher.dart';
import 'package:weather_bloc_app/screens/widgets/chatbot_chatbox.dart';
import 'package:weather_bloc_app/screens/widgets/chatbot_widget.dart';

import 'package:weather_bloc_app/screens/widgets/daily_forecast_widget.dart';
import 'package:weather_bloc_app/screens/widgets/location_dialog.dart';
import 'package:weather_bloc_app/screens/widgets/swipable_rectangle.dart';
import 'package:weather_bloc_app/screens/widgets/vertical_card.dart';
import 'package:weather_bloc_app/screens/widgets/weekly_forecast.dart';
import 'package:weather_bloc_app/screens/widgets/wind_direc_widget.dart';

import 'package:weather_bloc_app/services/get_greetings.dart';
import 'package:weather_bloc_app/services/get_weather_condition.dart';
import 'package:weather_bloc_app/services/get_wind_direc.dart';

import 'package:weather_bloc_app/services/handle_location.dart';
import 'package:weather_bloc_app/services/handle_location_connectivity.dart';
import 'package:weather_bloc_app/services/handle_refresh.dart';
import 'package:weather_bloc_app/services/today_low_high_temp.dart';

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

  bool _isChatOpen = false;

  void _toggleChatVisibility() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ForecastBloc, ForecastState>(builder: (context, state) {
      if (state is ForecastLoading) {
        return build_front(screenWidth, screenHeight);
      } else if (state is ForecastLoaded) {
        final forecastList = state.forecast.forecastList;
        final city = state.forecast.city.name;
        List<Map<String, dynamic>> hourlyData =
            HourlyData(context: context).getTodayHourlyData(forecastList);
        List<Map<String, dynamic>> weeklyData = getWeeklyData(forecastList);
        final lowTemp = getLowTemp(hourlyData);
        final highTemp = getHighTemp(hourlyData);

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
                ),
              ],
            ),
          );
        }

        return build_Homescreen(screenWidth, screenHeight, city, forecastList,
            highTemp, lowTemp, weeklyData, hourlyData);
      } else if (state is ForecastError) {
        return Center(child: Text('Error: ${state.message}'));
      }

      return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor2,
            ),
          ));
    });
  }

  Widget _buildShimmerItem(double width, double height) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 65, 57, 72),
      highlightColor: const Color.fromARGB(255, 187, 187, 187),
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 131, 131, 131),
            // borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget build_front(double screenWidth, double screenHeight) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: _buildShimmerItem(screenWidth * 0.5, screenHeight * 0.04),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.settings,
              size: screenWidth * 0.06,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentGeometry.directional(4, -0.5),
                  child: Container(
                    width: screenWidth * .7,
                    height: screenHeight * 0.6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.primaryColor2),
                  ),
                ),
                Align(
                  alignment: const AlignmentGeometry.directional(-4, -0.5),
                  child: Container(
                    width: screenWidth * .7,
                    height: screenHeight * 0.6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.primaryColor1),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 300.0, sigmaY: 300.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(children: [
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: screenWidth * 0.07, color: AppColors.white),
                  SizedBox(width: screenWidth * 0.02),
                  _buildShimmerItem(screenWidth * 0.5, screenHeight * 0.05),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildShimmerItem(screenWidth * 0.5, screenHeight * 0.20),
              SizedBox(
                height: screenHeight * 0.040,
              ),
              _buildShimmerItem(screenWidth * 0.2, screenHeight * 0.065),
              _buildShimmerItem(screenWidth * 0.3, screenHeight * 0.03),
              _buildShimmerItem(screenWidth * 0.25, screenHeight * 0.03),
              _buildShimmerItem(screenWidth * 0.3, screenHeight * 0.03),
              SizedBox(height: screenHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.air, size: screenHeight * 0.055),
                  Column(
                    children: [
                      const Text("Wind Speed",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      _buildShimmerItem(
                          screenWidth * 0.15, screenHeight * 0.03),
                    ],
                  ),
                  buildWindDirectionIcon(180, context),
                  Column(
                    children: [
                      const Text("Wind Direction",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      _buildShimmerItem(
                          screenWidth * 0.15, screenHeight * 0.03),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              const Divider(
                thickness: 2,
                color: AppColors.divider,
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
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      _buildShimmerItem(
                          screenWidth * 0.15, screenHeight * 0.03),
                    ],
                  ),
                  Icon(Icons.thermostat_sharp,
                      color: Colors.lightBlue, size: screenHeight * 0.055),
                  Column(
                    children: [
                      const Text("Min Temp",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      _buildShimmerItem(
                          screenWidth * 0.15, screenHeight * 0.03),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              const Divider(
                thickness: 2,
                color: AppColors.divider,
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.water_drop_rounded, size: screenHeight * 0.055),
                  Column(
                    children: [
                      const Text("Humidity",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      _buildShimmerItem(
                          screenWidth * 0.15, screenHeight * 0.03),
                    ],
                  ),
                  Icon(Icons.wb_cloudy_rounded, size: screenHeight * 0.055),
                  Column(
                    children: [
                      const Text("Clouds",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      _buildShimmerItem(
                          screenWidth * 0.15, screenHeight * 0.03),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _toggleChatVisibility,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor2,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/chatbot.png',
                      width: 40,
                    ),
                    const SizedBox(width: 6),
                    const Text("Cloudie",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build_Homescreen(
      double screenWidth,
      double screenHeight,
      String city,
      List<ForecastItem> forecastList,
      String highTemp,
      String lowTemp,
      List<Map<String, dynamic>> weeklyData,
      List<Map<String, dynamic>> hourlyData) {
    final today = forecastList.first;
    final date = DateTime.now();
    final formattedDate = DateFormat('EEEE d - h:mm a').format(date);
    final greetings = getGreeting(DateTime.now().hour);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentGeometry.directional(4, -0.3),
                  child: Container(
                    width: screenWidth * .7,
                    height: screenHeight * 0.6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.primaryColor2),
                  ),
                ),
                Align(
                  alignment: const AlignmentGeometry.directional(-4, -0.3),
                  child: Container(
                    width: screenWidth * .7,
                    height: screenHeight * 0.6,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.primaryColor1),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 300.0, sigmaY: 300.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          RefreshIndicator(
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
                        titlePadding: const EdgeInsets.all(10.0),
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
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => LocationDialog().ShowLocationDialog(
                                  context, screenWidth, screenHeight, city),
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
                        SizedBox(
                          height: screenHeight * 0.025,
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
                        SizedBox(height: screenHeight * 0.045),
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
                                Text(
                                    "${(today.wind.speed * 3.6).toStringAsFixed(1)} km/h",
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
                          color: AppColors.divider,
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
                                Text("$highTemp°C",
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
                                Text("$lowTemp°C",
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        const Divider(
                          thickness: 2,
                          color: AppColors.divider,
                        ),
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
                        SizedBox(height: screenHeight * 0.08),
                        SizedBox(
                          height: screenHeight * 0.18,
                          child: SwipableRectangle(
                            cards: Box1Data.getSampleList(
                                pressure: today.main.pressure,
                                seaLevel: today.main.seaLevel,
                                groundLevel: today.main.grndLevel),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: screenHeight * 0.3,
                                width: screenWidth * 0.45,
                                child: VerticalCard(
                                  icon: Icons.water_drop_rounded,
                                  title: "Rain Fall",
                                  description: "Chance of Rain",
                                  data: "${today.pop}%",
                                  trailText: today.pop > 0.5
                                      ? "High chance of rain today! Bring an umbrella."
                                      : "Almost No chance of rain Today!",
                                )),
                            SizedBox(
                                height: screenHeight * 0.3,
                                width: screenWidth * 0.45,
                                child: VerticalCard(
                                  icon: Icons.visibility,
                                  title: "Visibility",
                                  description: today.visibility > 1000
                                      ? "Good Visibility"
                                      : "Poor Visibility",
                                  data:
                                      "${(today.visibility / 100).toStringAsFixed(0)}%",
                                  trailText: today.visibility > 9000
                                      ? "Good visibility today! Drive safely."
                                      : "Poor visibility today! Drive carefully.",
                                )),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        HourlyForecastSlider(
                          hourlyData: hourlyData,
                          weatherDes:
                              today.weather.first.description.toUpperCase(),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        WeeklyForecastWidget(
                            weeklyData: weeklyData, forecast: forecastList),
                        SizedBox(height: screenHeight * 0.02),
                        SizedBox(
                            width: screenWidth,
                            child: ChatbotWidget(
                              walkPressed: () {
                                _toggleChatVisibility();
                                context
                                    .read<ChatBloc>()
                                    .add(SendUserMessage("Best time to walk?"));
                              },
                              rainPressed: () {
                                _toggleChatVisibility();
                                context.read<ChatBloc>().add(
                                    SendUserMessage("Will it rain today?"));
                              },
                              wearPressed: () {
                                _toggleChatVisibility();
                                context.read<ChatBloc>().add(SendUserMessage(
                                    "What should i wear today?"));
                              },
                              toggleChat: () {
                                _toggleChatVisibility();
                              },
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (!_isChatOpen)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _toggleChatVisibility,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor2,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/chatbot.png',
                        width: 40,
                      ),
                      const SizedBox(width: 6),
                      const Text("Cloudie",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          if (_isChatOpen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Material(
                  color: Colors.transparent,
                  child: ChatBoxBottomSheet(
                    onClose: _toggleChatVisibility,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
