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
                                items: categoryOptions.keys
                                    .map<DropdownMenuItem<String>>(
                                  (String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
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
                                      items: categoryOptions[selectedLocation!]!
                                          .map<DropdownMenuItem<String>>(
                                        (String category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
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
                          const Text(
                            'Alamat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: size.width,
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
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: TextField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Masukkan Alamat',
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
