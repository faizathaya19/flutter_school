import 'dart:async';
import 'dart:convert';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/widgets/buildButton_widget.dart';
import 'package:bpibs/ui/widgets/buildDropdownButton_widget.dart';
import 'package:bpibs/ui/widgets/buildTextField_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/const.dart';

import 'home_screen.dart';

class VisitregisformScreen extends StatefulWidget {
  static const id = 'VisitregisformScreen';

  const VisitregisformScreen({Key? key}) : super(key: key);

  @override
  VisitregisformScreenState createState() => VisitregisformScreenState();
}

class VisitregisformScreenState extends State<VisitregisformScreen> {
  String? selectedLocation;
  String? selectedTime;
  TextEditingController whatsappController = TextEditingController();

  Map<String, List<String>> visitOption = {
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

  Future<void> registerVisit(
    String nis,
    String location,
    String time,
    String whatsapp,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userProfile = prefs.getString('userProfile');
      if (userProfile != null) {
        Map<String, dynamic> profile = json.decode(userProfile);
        String nis = profile['nis'];

        final response = await http.post(
          Uri.parse(api),
          body: {
            'action': 'penjengukan_input',
            'nis': nis,
            'lokasi_kunjungan': location,
            'waktu_kunjungan': time,
            'no_whatsapp': whatsapp,
          },
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            // Data berhasil disimpan, tampilkan dialog sukses
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text('Success'),
                content: Text(jsonResponse['message']),
              ),
            );

            // Menunggu selama 5 detik sebelum pindah ke layar beranda
            Timer(const Duration(seconds: 3), () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(HomeScreen.id);
            });
          } else {
            // Gagal menambahkan data
            showErrorDialog(jsonResponse['message']);
          }
        } else {
          // Terjadi masalah pada server
          showErrorDialog('Terjadi masalah pada server.');
        }
      }
    } catch (e) {
      showErrorDialog('Terjadi masalah pada koneksi.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faiz athaya ramadhan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Periode kunjungan : Ahad,14 mei 2024'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildDropdownButton(
                      size: size,
                      value: selectedLocation,
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                          selectedTime = null;
                        });
                      },
                      items: visitOption.keys
                          .map<DropdownMenuItem<String>>(
                            (String category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      labelText: 'Lokasi Kunjungan',
                      hintText: 'Silakan Pilih',
                    ),
                    selectedLocation != null
                        ? BuildDropdownButton(
                            size: size,
                            value: selectedTime,
                            onChanged: (value) {
                              setState(() {
                                selectedTime = value;
                              });
                            },
                            items: visitOption[selectedLocation!]!
                                .map<DropdownMenuItem<String>>(
                                  (String category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            labelText: 'Waktu Kunjungan',
                            hintText: 'Silakan Pilih',
                          )
                        : const SizedBox(),
                    BuildTextField(
                      controller: whatsappController,
                      labelText: 'No WhatsApp',
                      size: size,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      maxLines: null,
                    ),
                    BuildButton(
                      width: double.infinity,
                      height: size.height / 16,
                      onTap: () {
                        String nis = ''; // Update with the actual nis value
                        String whatsapp = whatsappController.text;

                        if (selectedLocation != null && selectedTime != null) {
                          registerVisit(
                              nis, selectedLocation!, selectedTime!, whatsapp);
                        } else {
                          showErrorDialog(
                              'Mohon lengkapi data yang diperlukan.');
                        }
                      },
                      label: 'Kirim',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
