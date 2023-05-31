import 'package:flutter/material.dart';

import '../../constants/const.dart';

class CustomCard1 extends StatelessWidget {
  final String textharga;
  final String texttanggal;
  final String textstatus;

  const CustomCard1({
    super.key,
    required this.textharga,
    required this.texttanggal,
    required this.textstatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 160,
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textharga,
                    style: basicTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    texttanggal,
                    style: basicTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 197, 194, 194),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textstatus,
                        style: basicTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
