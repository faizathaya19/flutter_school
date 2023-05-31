import 'dart:convert';

import 'package:bpibs/constants/const.dart';
import 'package:bpibs/ui/Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'ProfileScreen';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        key: _scaffoldKey,
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
      body: (profile.isNotEmpty)
          ? Stack(
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
                                  'Nama Lengkap', '${profile['nama_lengkap']}'),
                              _buildDivider(),
                              _buildProfileItem('assets/icon/studentcenter.png',
                                  'NIS', '${profile['nis']}'),
                              _buildDivider(),
                              _buildProfileItem(
                                  'assets/icon/accountbalancewallet.png',
                                  'No Rekening VA',
                                  '${profile['no_rekening_va']}'),
                              _buildDivider(),
                              _buildProfileItem(
                                  'assets/icon/classroom.png',
                                  'Kelas',
                                  '${profile['kelas']} - ${profile['Jenis_kelamin']}'),
                              _buildDivider(),
                              _buildProfileItem('assets/icon/teacher.png',
                                  'Wali Kelas', '${profile['wali_kelas']}'),
                              _buildDivider(),
                              _buildProfileItem('assets/icon/bunkbed.png',
                                  'Asrama', '${profile['asrama']}'),
                              _buildDivider(),
                              _buildProfileItem('assets/icon/guardian.png',
                                  'Wali asrama', '${profile['wali_asrama']}'),
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
                                _buildProfileItem('assets/icon/phone.png',
                                    'No HP', '${profile['no_hp']}'),
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
            )
          : Center(
              child: CircularProgressIndicator(),
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
