import 'package:flutter/material.dart';

import '../../constants/const.dart';
import '../widgets/spppaymentrec_widget.dart';
import 'home_screen.dart';

class SPPPaymentrecScreen extends StatefulWidget {
  static const id = 'SPPPaymentrecScreen';
  const SPPPaymentrecScreen({super.key});

  @override
  State<SPPPaymentrecScreen> createState() => _SPPPaymentrecScreenState();
}

class _SPPPaymentrecScreenState extends State<SPPPaymentrecScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Rekap Pembayaran SPP',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {},
            child: CustomCard(
              textharga: 'Rp 4,900,000',
              texttanggal: 'Oktober 2022',
              textstatus: 'Lunas',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, SPPPaymentrecScreen.id);
            },
            child: CustomCard(
              textharga: 'Rp 4,900,000',
              texttanggal: 'Oktober 2022',
              textstatus: 'Belum Lunas',
            ),
          ),
        ],
      ),
    );
  }
}
