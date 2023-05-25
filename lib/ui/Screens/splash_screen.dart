import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/const.dart';
import '../widgets/splash_widget.dart';
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
    Future.delayed(const Duration(seconds: 5)).then((onValue) {
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
          ))
        ],
      ),
    );
  }
}
