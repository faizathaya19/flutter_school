import 'package:flutter/material.dart';

import '../../constants/const.dart';

import '../Screens/Login_screen.dart';
import '../Screens/changepass_screen.dart';

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

Widget drawerWidget(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: backgroundColor1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png',
                width: 150,
              ),
              Text(
                'Bintang Pelajar Boarding School',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.lightbulb),
          title: Text('Suggestions and Critics'),
          onTap: () {
            // TODO: Do something
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Information'),
          onTap: () {
            // TODO: Do something
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Change Password'),
          onTap: () {
            Navigator.pushReplacementNamed(context, ChangepassScreen.id);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.popAndPushNamed(context, LoginScreen.id);
          },
        ),
      ],
    ),
  );
}
