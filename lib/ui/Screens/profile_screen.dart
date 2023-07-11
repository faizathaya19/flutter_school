import 'dart:convert';

import 'package:bpibs/constants/const.dart';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  static const id = '';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> profile = {};

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString('userProfile');
    if (userProfile != null) {
      setState(() {
        profile = json.decode(userProfile);
      });
    }
  }

  Future<void> updateNoHp(String newNoHp) async {
    // Prepare the request data
    Map<String, dynamic> requestData = {
      'action': 'update_no_hp',
      'nis': profile['nis'],
      'new_no_hp': newNoHp,
    };

    // Make the API request
    Uri apiUrl = Uri.parse(api); // Ganti dengan URL API yang sesuai
    http.Response response = await http.post(apiUrl, body: requestData);
    if (response.statusCode == 200) {
      // API request berhasil, parsing data respons
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        // Perbarui profil dengan nomor HP baru
        setState(() {
          profile['no_hp'] = newNoHp;
        });

        // Tampilkan pesan sukses atau lakukan tindakan tambahan lainnya
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: Text(responseData['message']),
          ),
        );
      } else {
        // Tampilkan pesan error atau tangani kesalahan
        showErrorDialog(responseData['message']);
      }
    } else {
      // Tampilkan pesan error atau tangani kesalahan
      showErrorDialog('Terjadi masalah pada server saat memperbarui nomor HP.');
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
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        key: _scaffoldKey,
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
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: (profile.isNotEmpty)
          ? Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundColor1,
                          const Color(0xFFE1E1E1),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: backgroundCard1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Data Peserta Didik'),
                              _buildProfileItem(
                                'assets/icon/user.png',
                                'Nama Lengkap',
                                '${profile['nama_lengkap']}',
                              ),
                              _buildProfileItem(
                                'assets/icon/studentcenter.png',
                                'NIS',
                                '${profile['nis']}',
                              ),
                              _buildProfileItem(
                                'assets/icon/accountbalancewallet.png',
                                'No Rekening VA',
                                '${profile['no_rekening_va']}',
                              ),
                              _buildProfileItem(
                                'assets/icon/classroom.png',
                                'Kelas',
                                '${profile['kelas']} - ${profile['Jenis_kelamin']}',
                              ),
                              _buildProfileItem(
                                'assets/icon/teacher.png',
                                'Wali Kelas',
                                '${profile['wali_kelas']}',
                              ),
                              _buildProfileItem(
                                'assets/icon/bunkbed.png',
                                'Asrama',
                                '${profile['asrama']}',
                              ),
                              _buildProfileItem(
                                'assets/icon/guardian.png',
                                'Wali asrama',
                                '${profile['wali_asrama']}',
                              ),
                              _buildDivider(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: backgroundCard1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Kontak Orang Tua'),
                              _buildProfileItem(
                                'assets/icon/phone.png',
                                'No HP',
                                '${profile['no_hp']}',
                              ),
                              _buildDivider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  '* no hp ini akan digunakan untuk pengiriman informasi dan notifikasi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              _buildSectionButton(
                                'Update No HP',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String newNoHp =
                                          ''; // Tambahkan variabel untuk menyimpan nomor HP baru
                                      return AlertDialog(
                                        title: const Text('Update No HP'),
                                        content: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Enter new number',
                                          ),
                                          onChanged: (value) {
                                            newNoHp =
                                                value; // Simpan nomor HP baru saat berubah
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              updateNoHp(
                                                  newNoHp); // Panggil fungsi updateNoHp dengan nomor HP baru
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Update'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileItem(String imagePath, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF0A0000),
      height: 1,
      thickness: 2,
      indent: 48,
      endIndent: 20,
    );
  }

  Widget _buildSectionButton(String label, {required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
