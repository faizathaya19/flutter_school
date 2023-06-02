import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class VisitregisformScreen extends StatefulWidget {
  static const id = 'VisitregisformScreen';

  @override
  _VisitregisformScreenState createState() => _VisitregisformScreenState();
}

class _VisitregisformScreenState extends State<VisitregisformScreen> {
  String? selectedLocation;
  String? selectedTime;

  List<String> locations = [
    'Tetap di area BPIBS',
    'Keluar area BPIBS',
  ];

  Map<String, List<String>> timeOptions = {
    'Tetap di area BPIBS': [
      '07.00 - 09.00',
      '09.30 - 11.00',
      '13.00 - 14.30',
      '15.00 - 17.00',
    ],
    'Keluar area BPIBS': [
      '07.00 - 17.00',
    ],
  };

  TextEditingController whatsappController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
          'Form Pendaftaran Kunjungan Wali Siswa',
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
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Faiz Athaya Ramadhan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Periode Kunjungan Ahad, 14 Mei 2023'),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: backgroundCard1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lokasi Kunjungan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: DropdownButton<String>(
                              value: selectedLocation,
                              onChanged: (value) {
                                setState(() {
                                  selectedLocation = value;
                                  selectedTime = null;
                                });
                              },
                              underline: SizedBox(),
                              isExpanded: true,
                              items: locations.map<DropdownMenuItem<String>>(
                                  (String location) {
                                return DropdownMenuItem<String>(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                              hint: Text('Pilih lokasi kunjungan'),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Waktu Kunjungan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selectedLocation != null
                            ? Container(
                                width: size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: DropdownButton<String>(
                                    value: selectedTime,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTime = value;
                                      });
                                    },
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    items: timeOptions[selectedLocation!]!
                                        .map<DropdownMenuItem<String>>(
                                      (String time) {
                                        return DropdownMenuItem<String>(
                                          value: time,
                                          child: Text(time),
                                        );
                                      },
                                    ).toList(),
                                    hint: Text('Pilih waktu kunjungan'),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 16),
                        Text(
                          'No Whatsapp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: whatsappController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Masukkan No Whatsapp',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(child: kirimButton(size, context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget kirimButton(Size size, BuildContext context) {
    return Container(
      width: 300,
      height: size.height / 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: buttonColor1,
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        },
        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
