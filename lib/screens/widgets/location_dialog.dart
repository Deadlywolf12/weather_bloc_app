import 'package:flutter/material.dart';

import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class LocationDialog {
  void ShowLocationDialog(BuildContext context, double screenWidth,
      double screenHeight, String city) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.tiles,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Current Location",
                      style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Text(
                      city,
                      style: TextStyle(fontSize: screenWidth * 0.05),
                    ),
                  ],
                ),
              ),
            ));
  }
}
