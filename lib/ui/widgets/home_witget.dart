import 'package:flutter/material.dart';

import '../../constants/const.dart';

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String text;

  const CustomCard({
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: 180,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 80,
              ),
              const SizedBox(height: 12),
                Text(
                text,
                style: basicTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
