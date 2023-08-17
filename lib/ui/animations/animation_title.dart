import 'package:flutter/material.dart';

import '../../constants/const.dart';

class AnimatedTitle extends StatelessWidget {
  final bool isLoading;
  final String title;
  final double fontsize;

  const AnimatedTitle({
    required this.isLoading,
    required this.title,
    required this.fontsize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLoading ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      child: Text(
        title,
        style: basicTextStyle.copyWith(
          fontSize: fontsize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
