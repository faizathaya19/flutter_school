import 'package:flutter/material.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class ArchievpointsrecScreen extends StatefulWidget {
  static const id ='ArchievpointsrecScreen';
  const ArchievpointsrecScreen({super.key});

  @override
  State<ArchievpointsrecScreen> createState() => _ArchievpointsrecScreenState();
}

class _ArchievpointsrecScreenState extends State<ArchievpointsrecScreen> {
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
          'Rekap Poin Prestasi',
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
