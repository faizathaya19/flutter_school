import 'package:bpibs/ui/screens/achievpointsrec_screen.dart';
import 'package:bpibs/ui/screens/changepass_screen.dart';
import 'package:bpibs/ui/screens/criticsform_screen.dart';
import 'package:bpibs/ui/screens/forgetpass_screen.dart';
import 'package:bpibs/ui/screens/home_screen.dart';
import 'package:bpibs/ui/screens/information_screen.dart';
import 'package:bpibs/ui/screens/login_screen.dart';
import 'package:bpibs/ui/screens/pickupregisform_screen.dart';
import 'package:bpibs/ui/screens/pocketmoneyrec_screen.dart';
import 'package:bpibs/ui/screens/profile_screen.dart';
import 'package:bpibs/ui/screens/raports_screen.dart';
import 'package:bpibs/ui/screens/splash_screen.dart';
import 'package:bpibs/ui/screens/spppaymentrec_screen.dart';
import 'package:bpibs/ui/screens/suggestionsandcritics_screen.dart';
import 'package:bpibs/ui/screens/visitregisform_screen.dart';

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
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        SPPPaymentrecScreen.id: (context) => const SPPPaymentrecScreen(),
        VisitregisformScreen.id: (context) => const VisitregisformScreen(),
        ChangepassScreen.id: (context) => const ChangepassScreen(),
        PocketmoneyrecScreen.id: (context) => const PocketmoneyrecScreen(),
        ArchievpointsrecScreen.id: (context) => const ArchievpointsrecScreen(),
        PickupregisformScreen.id: (context) => const PickupregisformScreen(),
        SuggestionsAndCriticsScreen.id: (context) =>
            const SuggestionsAndCriticsScreen(),
        CriticsformScreen.id: (context) => const CriticsformScreen(),
        InformationScreen.id: (context) => const InformationScreen(),
        RaportsScreen.id: (context) => const RaportsScreen(),
      },
    );
  }
}
