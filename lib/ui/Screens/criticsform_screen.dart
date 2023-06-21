import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class CriticsformScreen extends StatefulWidget {
  static const id = 'CriticsformScreen';

  @override
  _CriticsformScreenState createState() => _CriticsformScreenState();
}

class _CriticsformScreenState extends State<CriticsformScreen> {
  String? selectedLocation;
  String? selectedTime;

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

  TextEditingController whatsappController = TextEditingController();

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
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
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
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
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
                      const Text(
                        'Lokasi Kunjungan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildDropdownButton(
                        value: selectedLocation,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                            selectedTime = null;
                          });
                        },
                        items:
                            categoryOptions.keys.map<DropdownMenuItem<String>>(
                          (String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          },
                        ).toList(),
                        hintText: 'Pilih lokasi kunjungan',
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
                          ? buildDropdownButton(
                              value: selectedTime,
                              onChanged: (value) {
                                setState(() {
                                  selectedTime = value;
                                });
                              },
                              items: categoryOptions[selectedLocation!]!
                                  .map<DropdownMenuItem<String>>(
                                (String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                },
                              ).toList(),
                              hintText: 'Pilih waktu kunjungan',
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
                      buildTextField(
                        controller: whatsappController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        hintText: 'Masukkan No Whatsapp',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Alamat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildMultilineTextField(
                        keyboardType: TextInputType.multiline,
                        hintText: 'Masukkan Alamat',
                      ),
                      const SizedBox(height: 16),
                      Center(child: kirimButton(size)),
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

  Widget buildDropdownButton({
    required String? value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
    required String hintText,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          underline: const SizedBox(),
          isExpanded: true,
          items: items,
          hint: Text(hintText),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
    required String hintText,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildMultilineTextField({
    required TextInputType keyboardType,
    required String hintText,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          maxLines: null,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
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
          String whatsapp = whatsappController.text;
          if (selectedLocation != null && selectedTime != null) {
            // Panggil fungsi untuk mengirim data
            _sendData(selectedLocation!, selectedTime!, whatsapp);
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

  void _sendData(String location, String time, String whatsapp) {
    // Implementasikan logika untuk mengirim data ke server atau melakukan tindakan lain
    // Misalnya, tampilkan dialog sukses dan navigasi ke halaman lain
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Data berhasil dikirim.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigasi ke halaman beranda
              Navigator.of(context).pushNamed(HomeScreen.id);
            },
          ),
        ],
      ),
    );
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
}
