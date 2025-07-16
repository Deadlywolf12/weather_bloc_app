import 'package:flutter/material.dart';
import 'package:weather_bloc_app/services/weatherAdvices/ground_lvl_advices.dart';
import 'package:weather_bloc_app/services/weatherAdvices/pressure_alert.dart';
import 'package:weather_bloc_app/services/weatherAdvices/seaLvl_advice.dart';

class Box1Data {
  final IconData icon;
  final String title;
  final String description;
  final dynamic data;

  Box1Data({
    required this.icon,
    required this.title,
    required this.description,
    required this.data,
  });

  static List<Box1Data> getSampleList({
    required int pressure,
    required int seaLevel,
    required int groundLevel,
  }) {
    final pressureData = getPressureAdvice(pressure);
    final seaLvlData = getSeaLevelAdvice(seaLevel);
    final gLvlData = getGroundLevelAdvice(groundLevel);
    return [
      Box1Data(
        icon: Icons.speed,
        title: "Pressure",
        description: pressureData,
        data: "$pressure hPa",
      ),
      Box1Data(
        icon: Icons.terrain,
        title: "Sea Level",
        description: seaLvlData,
        data: "$seaLevel hPa",
      ),
      Box1Data(
        icon: Icons.landslide,
        title: "Ground Level",
        description: gLvlData,
        data: "$groundLevel hPa",
      ),
    ];
  }
}
