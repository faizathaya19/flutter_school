import 'package:flutter/material.dart';

Widget logo(double height_, double width_) {
  return Image.asset(
    'assets/Logo.png',
    width: 238,
  );
}

Widget textbpibs(Size size) {
  return const Column(
    children: [
      Text(
        "Bintang Pelajar",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
