import 'package:flutter/material.dart';

Widget buildWindDirectionIcon(double degree, BuildContext context) {
  return Transform.rotate(
    angle: degree * 3.1416 / 180,
    child: Icon(
      Icons.navigation,
      size: MediaQuery.of(context).size.height * 0.055,
    ),
  );
}
