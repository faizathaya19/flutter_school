import 'package:bpibs/constants/const.dart';
import 'package:bpibs/ui/widgets/BuildButton_Widget.dart';
import 'package:flutter/material.dart';

Future<void> showSuccessDialog(
    BuildContext context, String message, VoidCallback onTap) async {
  final Size size = MediaQuery.of(context).size;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: backgroundColor1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/success_image.png', // Replace with your actual image path
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),
          const Text(
            'Success',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message, // Replace with your error message
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center, // Align the text in the center
          ),
        ],
      ),
      actions: <Widget>[
        BuildButton(
          width: double.infinity,
          height: size.height / 16,
          label: 'OK',
          onTap: onTap,
        )
      ],
    ),
  );
}

Future<void> showErrorDialog(
    BuildContext context, String message, VoidCallback onTap) async {
  final Size size = MediaQuery.of(context).size;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: backgroundColor1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/error_image.png', // Replace with your actual image path
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 10),
          const Text(
            'Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message, // Replace with your error message
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center, // Align the text in the center
          ),
        ],
      ),
      actions: <Widget>[
        BuildButton(
          width: double.infinity,
          height: size.height / 16,
          label: 'Close',
          onTap: onTap,
        )
      ],
    ),
  );
}
