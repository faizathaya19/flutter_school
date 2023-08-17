import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/const.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1, milliseconds: 30))
        .then((onValue) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    });
    // Sembunyikan keyboard jika aktif
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Stack(
        children: [
          topbg(),
          bottombg(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                logo(160, 160),
                const SizedBox(
                  height: 25,
                ),
                textbpibs(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topbg() {
    return Positioned.fill(
      right: -150,
      child: Opacity(
        opacity: 0.3,
        child: Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            'assets/Logo.png',
            width: 478,
          ),
        ),
      ),
    );
  }

  Widget bottombg() {
    return Positioned.fill(
      left: -150,
      child: Opacity(
        opacity: 0.3,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Image.asset(
            'assets/Logo.png',
            width: 731,
          ),
        ),
      ),
    );
  }

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
}
