import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class ChatBubble {
  Widget createChatBubble(bool isBot, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            Icon(
              Icons.circle,
              size: 20,
              color: Color.fromARGB(255, 114, 99, 131),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isBot
                    ? const Color.fromARGB(255, 114, 99, 131)
                    : const Color.fromARGB(255, 143, 96, 198),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isBot
                      ? const Radius.circular(0)
                      : const Radius.circular(20),
                  bottomRight: isBot
                      ? const Radius.circular(20)
                      : const Radius.circular(0),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (!isBot) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.circle,
              size: 20,
              color: AppColors.primaryColor2,
            ),
          ],
        ],
      ),
    );
  }
}
