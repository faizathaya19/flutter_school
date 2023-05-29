import 'package:flutter/material.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class PocketmoneyrecScreen extends StatefulWidget {
  static const id = 'PocketmoneyrecScreen';
  const PocketmoneyrecScreen({super.key});

  @override
  State<PocketmoneyrecScreen> createState() => _PocketmoneyrecScreenState();
}

class _PocketmoneyrecScreenState extends State<PocketmoneyrecScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100, // Atur tinggi khusus untuk toolbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Rekap Uang Saku',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
