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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Global key
  static final globalKey = GlobalKey<NavigatorState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalKey, // Use globalKey as navigatorKey
      debugShowCheckedModeBanner: false,
      title: 'BPIBS Mobile',
      theme: ThemeData.light(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgetpassScreen.id: (context) => const ForgetpassScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SPPPaymentrecScreen.id: (context) => SPPPaymentrecScreen(),
        VisitregisformScreen.id: (context) => VisitregisformScreen(),
        ChangepassScreen.id: (context) => ChangepassScreen(),
        PocketmoneyrecScreen.id: (context) => PocketmoneyrecScreen(),
        ArchievpointsrecScreen.id: (context) => ArchievpointsrecScreen(),
        PickupregisformScreen.id: (context) => PickupregisformScreen(),
      },
    );
  }
}
