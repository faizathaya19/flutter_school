import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> registerVisit(
      String nis, String location, String time, String whatsapp) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userProfile = prefs.getString('userProfile');
      if (userProfile != null) {
        Map<String, dynamic> profile = json.decode(userProfile);
        String nis = profile['nis'];

        final response = await http.post(
          Uri.parse('http://192.168.1.2/mybpibs-api/api/api.php'),
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
            Timer(const Duration(seconds: 5), () {
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
                    const Text(
                      'Lokasi Kunjungan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    dropdownWidget(
                      items: locations,
                      selectedValue: selectedLocation,
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                          selectedTime = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Waktu Kunjungan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (selectedLocation != null)
                      dropdownWidget(
                        items: timeOptions[selectedLocation!]!,
                        selectedValue: selectedTime,
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
                        },
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Whatsapp',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: whatsappController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
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
                    const SizedBox(height: 30),
                    Center(child: kirimButton(size)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropdownWidget({
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          isExpanded: true,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          hint: const Text('Pilih'),
        ),
      ),
    );
  }

  Widget kirimButton(Size size) {
    return Container(
      width: 300,
      height: size.height / 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: buttonColor1,
      ),
      child: TextButton(
        onPressed: () {
          String nis = ''; // Update with the actual nis value
          String whatsapp = whatsappController.text;
          if (selectedLocation != null && selectedTime != null) {
            registerVisit(nis, selectedLocation!, selectedTime!, whatsapp);
          } else {
            showErrorDialog('Mohon lengkapi data yang diperlukan.');
          }
        },
        child: const Text(
          'Kirim',
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
