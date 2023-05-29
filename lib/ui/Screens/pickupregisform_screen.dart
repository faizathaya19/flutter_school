import 'package:flutter/material.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class PickupregisformScreen extends StatefulWidget {
  static const id = 'PickupregisformScreen';
  const PickupregisformScreen({super.key});

  @override
  State<PickupregisformScreen> createState() => _PickupregisformScreenState();
}

class _PickupregisformScreenState extends State<PickupregisformScreen> {
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
          'Form Pendaftaran Penjemputan Wali Siswa',
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
