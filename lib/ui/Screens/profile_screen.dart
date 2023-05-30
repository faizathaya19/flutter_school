import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bpibs/constants/const.dart';
import 'package:bpibs/ui/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'ProfileScreen';

  final String nis;

  const ProfileScreen(this.nis);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String namaLengkap = '';
  String jenisKelamin = '';
  String noRekeningVA = '';
  String kelas = '';
  String waliKelas = '';
  String asrama = '';
  String waliAsrama = '';
  String noHP = '';

  Future<void> _fetchProfile() async {
    String nis = widget.nis;

    // Ganti URL_API dengan URL yang sesuai
    String url = 'https://shoesez.000webhostapp.com/get_user.php?nis=$nis';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          namaLengkap = data['nama_lengkap'];
          jenisKelamin = data['jenis_kelamin'];
          noRekeningVA = data['no_rekening_va'];
          kelas = data['kelas'];
          waliKelas = data['wali_kelas'];
          asrama = data['asrama'];
          waliAsrama = data['wali_asrama'];
          noHP = data['no_hp'];
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal mendapatkan data profil. Silakan coba lagi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
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
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          topbg(),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 450,
                    width: 380,
                    decoration: BoxDecoration(
                      color: backgroundCard1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Data Peserta Didik',
                            style: basicTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                        _buildProfileItem('assets/icon/user.png',
                            'Nama Lengkap', namaLengkap),
                        _buildDivider(),
                        _buildProfileItem('assets/icon/studentcenter.png',
                            'NIS', '2122011003'),
                        _buildDivider(),
                        _buildProfileItem(
                            'assets/icon/accountbalancewallet.png',
                            'No Rekening VA',
                            '21222018'),
                        _buildDivider(),
                        _buildProfileItem('assets/icon/classroom.png', 'Kelas',
                            '10 IPA - Akhwat'),
                        _buildDivider(),
                        _buildProfileItem(
                            'assets/icon/teacher.png', 'kelas', ''),
                        _buildDivider(),
                        _buildProfileItem('assets/icon/bunkbed.png', 'Asrama',
                            'Lubaabah Bintu Haarits'),
                        _buildDivider(),
                        _buildProfileItem('assets/icon/guardian.png',
                            'Wali asrama', 'Ustadzah Afifah Nur Indallah'),
                        _buildDivider(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: 230,
                      width: 380,
                      decoration: BoxDecoration(
                        color: backgroundCard1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Kontak Orang Tua',
                              style: basicTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          _buildProfileItem(
                              'assets/icon/phone.png', 'No HP', '08129852612'),
                          _buildDivider(),
                          const Padding(
                            padding: EdgeInsets.only(right: 20, left: 45),
                            child: Text(
                                '* no hp ini akan digunakan untuk pengiriman informasi dan notifikasi'),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, bottom: 20),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implement your logic here
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        buttonColor1, // Ubah warna menjadi merah
                                  ),
                                  child: Text(
                                    'Update No HP',
                                    style: primaryTextStyle.copyWith(
                                      fontSize: 15,
                                      fontWeight: bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildProfileItem(String imagePath, String title, String subtitle) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(imagePath),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.left,
              style: basicTextStyle.copyWith(
                fontSize: 14,
                fontWeight: bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 45, right: 20),
      child: Divider(
        color: Color.fromARGB(255, 10, 0, 0),
        height: 1,
        thickness: 2,
      ),
    );
  }
}
