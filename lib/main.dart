import 'package:bpibs/ui/Screens/forgetpass_screen.dart';
import 'package:bpibs/ui/Screens/home_screen.dart';
import 'package:bpibs/ui/Screens/profile_screen.dart';
import 'package:bpibs/ui/Screens/splash_screen.dart';
import 'package:bpibs/ui/Screens/Login_screen.dart';
import 'package:bpibs/ui/Screens/spppaymentrec_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BPIBS Mobile',
      theme: ThemeData.light(),
      initialRoute: SplashScreen.id,
      routes: {

        LoginScreen.id: (context) => const LoginScreen(),
        ForgetpassScreen.id: (context) => const ForgetpassScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        SPPPaymentrecScreen.id: (context) => const SPPPaymentrecScreen(),
      },
    );
  }
}
