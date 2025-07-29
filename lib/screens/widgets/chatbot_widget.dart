import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';
import 'package:weather_bloc_app/screens/widgets/chat_launcher.dart';

class ChatbotWidget extends StatelessWidget {
  final VoidCallback walkPressed;
  final VoidCallback rainPressed;
  final VoidCallback wearPressed;
  final VoidCallback toggleChat;
  const ChatbotWidget(
      {super.key,
      required this.walkPressed,
      required this.rainPressed,
      required this.wearPressed,
      required this.toggleChat});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Card(
      elevation: 6,
      shadowColor: AppColors.primaryColor2.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.gradColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/chatbot.png',
                  width: width * 0.25,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Hey! I'm Cloudie ☁️\nYour friendly forecast cloud.\nAsk me anything, anytime!",
                    softWrap: true,
                    style: TextStyle(
                      fontSize: width * 0.039,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.tiles)
                  .copyWith(),
              onPressed: walkPressed,
              child: Text("Best Time to walk?"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.tiles)
                  .copyWith(),
              onPressed: rainPressed,
              child: Text("Will it Rain today?"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.tiles)
                  .copyWith(),
              onPressed: wearPressed,
              child: Text("What should i wear today?"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: toggleChat,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tiles,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.035,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
