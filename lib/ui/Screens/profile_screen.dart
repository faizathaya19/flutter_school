import 'package:bpibs/constants/const.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'ProfileScreen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Stack(
        children: [
          topbg(),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
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
                              'Nama Lengkap', 'Aisyah Syafa Atifah'),
                          _buildDivider(),
                          _buildProfileItem('assets/icon/studentcenter.png',
                              'NIS', '2122011003'),
                          _buildDivider(),
                          _buildProfileItem(
                              'assets/icon/accountbalancewallet.png',
                              'No Rekening VA',
                              '21222018'),
                          _buildDivider(),
                          _buildProfileItem('assets/icon/classroom.png',
                              'Kelas', '10 IPA - Akhwat'),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 45),
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
    return Padding(
      padding: EdgeInsets.only(left: 45, right: 20),
      child: Divider(
        color: Color.fromARGB(255, 10, 0, 0),
        height: 1,
        thickness: 2,
      ),
    );
  }
}