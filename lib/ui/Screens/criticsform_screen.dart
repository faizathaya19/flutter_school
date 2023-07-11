import 'dart:async';
import 'dart:convert';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/screens/suggestionsandcritics_screen.dart';
import 'package:bpibs/ui/widgets/buildButton_widget.dart';
import 'package:bpibs/ui/widgets/buildDropdownButton_widget.dart';
import 'package:bpibs/ui/widgets/buildTextField_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/const.dart';

class CriticsformScreen extends StatefulWidget {
  static const id = 'CriticsformScreen';

  const CriticsformScreen({Key? key}) : super(key: key);

  @override
  CriticsformScreenState createState() => CriticsformScreenState();
}

class CriticsformScreenState extends State<CriticsformScreen> {
  String? selectedDivisi;
  String? selectedCategory;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Map<String, List<String>> categoryOptions = {
    'SMA': ['Akademik', 'Kunjungan', 'Jadwal', 'Lainnya'],
    'SMP': ['Akademik', 'Kunjungan', 'Jadwal', 'Lainnya'],
    'Asrama': ['Halaqah', 'Penelponan', 'Distribusi', 'Lainnya', 'Perijinan'],
    'Sarana Prasarana': ['Bangunan', 'Keamanan', 'CCTV', 'Lainnya'],
    'Rumah Tangga': [
      'Catering dan Makanan',
      'Laundry',
      'Kebersihan',
      'Lainnya'
    ],
    'Kesehatan': ['Info kesehatan', 'Lainnya'],
    'Keuangan': [
      'Info Rekening',
      'Metode Pembayaran',
      'Konfirmasi Pembayaran',
      'SPP dan Biaya Lainnya',
      'Uang Saku',
      'Lainnya'
    ],
  };

  Future<void> registerCriticsSuggestion(
    String nis,
    String divisi,
    String kategori,
    String subjek,
    String pesan,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userProfile = prefs.getString('userProfile');
      if (userProfile != null) {
        Map<String, dynamic> profile = json.decode(userProfile);
        nis = profile['nis'];

        final response = await http.post(
          Uri.parse(api),
          body: {
            'action': 'kritik_saran_input',
            'nis': nis,
            'divisi': divisi,
            'kategori': kategori,
            'subjek': subjek,
            'pesan': pesan,
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
                title: const Text('Sukses'),
                content: Text(jsonResponse['message']),
              ),
            );

            // Menunggu selama 5 detik sebelum pindah ke layar beranda
            Timer(const Duration(seconds: 2), () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(SuggestionsAndCriticsScreen.id);
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
            Navigator.popAndPushNamed(context, SuggestionsAndCriticsScreen.id);
          },
        ),
        title: const Text(
          'Kritik dan Saran',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildDropdownButton(
                        size: size,
                        value: selectedDivisi,
                        onChanged: (value) {
                          setState(() {
                            selectedDivisi = value;
                            selectedCategory = null;
                          });
                        },
                        items: categoryOptions.keys
                            .map<DropdownMenuItem<String>>(
                              (String category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        labelText: 'Bidang Terkait',
                        hintText: 'Silakan Pilih',
                      ),
                      selectedDivisi != null
                          ? BuildDropdownButton(
                              size: size,
                              value: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              items: categoryOptions[selectedDivisi!]!
                                  .map<DropdownMenuItem<String>>(
                                    (String category) =>
                                        DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    ),
                                  )
                                  .toList(),
                              labelText: 'Kategori',
                              hintText: 'Silakan Pilih',
                            )
                          : const SizedBox(),
                      BuildTextField(
                        controller: subjectController,
                        labelText: 'Masukkan Judul',
                        size: size,
                        maxLines: null,
                      ),
                      BuildTextField(
                        controller: messageController,
                        labelText: 'Pesan Anda',
                        size: size,
                        maxLines: null,
                      ),
                      BuildButton(
                        width: double.infinity,
                        height: size.height / 16,
                        onTap: () {
                          String nis = ''; // Update with the actual nis value
                          String subject = subjectController.text;
                          String message = messageController.text;
                          if (selectedDivisi != null &&
                              selectedCategory != null) {
                            registerCriticsSuggestion(nis, selectedDivisi!,
                                selectedCategory!, subject, message);
                          } else {
                            showErrorDialog(
                                'Mohon lengkapi data yang diperlukan.');
                          }
                        },
                        label: 'Kirim',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
