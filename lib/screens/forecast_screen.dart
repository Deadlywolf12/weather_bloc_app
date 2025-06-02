import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class ForecastContent extends StatelessWidget {
  const ForecastContent();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
        initialChildSize: 0.49,
        minChildSize: 0.45,
        maxChildSize: 0.55,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryColor1,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: 5,
            itemBuilder: (_, i) => ListTile(
              leading: Image.asset(
                "assets/sun.png",
                height: 45,
              ),
              title: Text(
                'Day ${i + 1}',
                style: TextStyle(
                    color: AppColors.black, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                "Partly cloudy with chance of rain",
                style: TextStyle(color: AppColors.black),
              ),
              trailing: const Text(
                "23°C",
                style: TextStyle(color: AppColors.black, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
