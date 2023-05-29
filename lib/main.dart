import 'package:bpibs/ui/Screens/achievpointsrec_screen.dart';
import 'package:bpibs/ui/Screens/changepass_screen.dart';
import 'package:bpibs/ui/Screens/forgetpass_screen.dart';
import 'package:bpibs/ui/Screens/home_screen.dart';
import 'package:bpibs/ui/Screens/pickupregisform_screen.dart';
import 'package:bpibs/ui/Screens/pocketmoneyrec_screen.dart';
import 'package:bpibs/ui/Screens/profile_screen.dart';
import 'package:bpibs/ui/Screens/splash_screen.dart';
import 'package:bpibs/ui/Screens/Login_screen.dart';
import 'package:bpibs/ui/Screens/spppaymentrec_screen.dart';
import 'package:bpibs/ui/Screens/visitregisform_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding

  // Disable screen rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgetpassScreen.id: (context) => const ForgetpassScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        SPPPaymentrecScreen.id: (context) => const SPPPaymentrecScreen(),
        VisitregisformScreen.id: (context) => const VisitregisformScreen(),
        ChangepassScreen.id: (context) => const ChangepassScreen(),
        PocketmoneyrecScreen.id: (context) => const PocketmoneyrecScreen(),
        ArchievpointsrecScreen.id: (context) => const ArchievpointsrecScreen(),
        PickupregisformScreen.id: (context) => const PickupregisformScreen(),
      },
    );
  }
}
