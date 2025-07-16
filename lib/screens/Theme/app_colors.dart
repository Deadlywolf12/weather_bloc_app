import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor1 = Color.fromARGB(255, 115, 130, 213);
  static const primaryColor2 = Color.fromARGB(255, 182, 122, 243);
  static const tiles = Color.fromARGB(255, 72, 47, 97);
  static const gradColor = LinearGradient(
    colors: [AppColors.primaryColor1, AppColors.primaryColor2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const black = Colors.black;
  static const white = Colors.white;
  static const background = Color.fromARGB(255, 28, 18, 37);
}
