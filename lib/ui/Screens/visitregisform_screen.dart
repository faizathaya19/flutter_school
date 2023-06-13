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
          Uri.parse('http://192.168.1.5/mybpibs-api/api/api.php'),
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
      body: SingleChildScrollView(
        // Tambahkan widget SingleChildScrollView di sekitar konten formulir
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                child: const Padding(
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
                                underline: const SizedBox(),
                                isExpanded: true,
                                items: locations.map<DropdownMenuItem<String>>(
                                  (String location) {
                                    return DropdownMenuItem<String>(
                                      value: location,
                                      child: Text(location),
                                    );
                                  },
                                ).toList(),
                                hint: const Text('Pilih lokasi kunjungan'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
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
                                      underline: const SizedBox(),
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
                                      hint: const Text('Pilih waktu kunjungan'),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 16),
                          const Text(
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
                          const SizedBox(height: 16),
                          Center(child: kirimButton(size)),
                        ],
                      ),
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
