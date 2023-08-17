import 'package:flutter/material.dart';

import '../../constants/const.dart';

class BuildButton extends StatelessWidget {
  final double height;
  final VoidCallback onTap;
  final double width;
  final String label;
  final bool isLoading = false;

  const BuildButton({
    Key? key,
    required this.height,
    required this.onTap,
    required this.width,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: buttonColor1,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position [horizontal, vertical]
              ),
            ],
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
