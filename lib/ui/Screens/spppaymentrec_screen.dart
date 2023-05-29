import 'package:flutter/material.dart';

import '../../constants/const.dart';
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
        body: Stack(
          children: [
            SafeArea(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                      child: GridView.count(
                    crossAxisCount: 2,
                    children: [
                      Card(
                        elevation: 4,
                        child: Column(
                          children: [
                            Text('Rp 4,900,000'),
                            Text(
                              'Oktober 2022',
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 50,
                                  width: 250,
                                  color: Colors.green,
                                  child: Text('Lunas'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ))
          ],
        ));
  }
}
