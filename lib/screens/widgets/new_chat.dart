import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

Widget buildWelcomeMessage() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset('assets/chatbot.png', width: 40),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Hey! I'm Cloudie 👋\nHow can I help you today?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "You can try asking:",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            _suggestionChip("Best time to walk?"),
            _suggestionChip("Will it rain today?"),
            _suggestionChip("5-day forecast"),
            _suggestionChip("What's the temperature?"),
          ],
        )
      ],
    ),
  );
}

Widget _suggestionChip(String label) {
  return ActionChip(
    label: Text(label),
    onPressed: () {
      // You can send this as a user message or call a function
      print("User tapped: $label");
    },
    backgroundColor: AppColors.tiles,
    labelStyle: TextStyle(color: Colors.white),
  );
}
