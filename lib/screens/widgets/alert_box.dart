import 'package:flutter/material.dart';
import 'package:weather_bloc_app/screens/Theme/app_colors.dart';

class AlertBox {
  final String title;
  final String content;
  final String btn1;
  final String btn2;
  VoidCallback onBtn1Pressed;
  VoidCallback onBtn2Pressed;
  AlertBox(
      {required this.title,
      required this.content,
      required this.btn1,
      required this.btn2,
      required this.onBtn1Pressed,
      required this.onBtn2Pressed});

  void showCustomAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // prevent dismiss on outside tap
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            content,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            OutlinedButton(
              onPressed: onBtn1Pressed,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: Colors.grey),
              ),
              child: Text(btn1),
            ),
            ElevatedButton(
              onPressed: onBtn2Pressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor1,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(btn2),
            ),
          ],
        );
      },
    );
  }
}
