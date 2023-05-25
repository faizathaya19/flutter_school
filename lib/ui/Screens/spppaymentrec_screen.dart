import 'package:flutter/material.dart';

import '../../constants/const.dart';

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
