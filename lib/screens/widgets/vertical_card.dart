import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class VerticalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String data;
  final String trailText;

  const VerticalCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.data,
    required this.trailText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.gradColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),
              Text(description,
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 5),
              Text(data,
                  style: const TextStyle(
                      fontSize: 40,
                      color: AppColors.tiles,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(trailText,
                  style: const TextStyle(fontSize: 13, color: Colors.white70)),
            ],
          ),
        ));
  }
}
