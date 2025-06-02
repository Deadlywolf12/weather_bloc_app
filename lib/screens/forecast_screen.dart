import 'package:flutter/material.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("5-Day Forecast"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.white),
            title: Text(
              "Day ${index + 1}: 25°C / 18°C",
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: const Text("Partly Cloudy",
                style: TextStyle(color: Colors.grey)),
          );
        },
      ),
    );
  }
}
