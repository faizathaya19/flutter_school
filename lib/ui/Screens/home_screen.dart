import 'package:bpibs/ui/Screens/login_screen.dart';
import 'package:bpibs/ui/Screens/pickupregisform_screen.dart';
import 'package:bpibs/ui/Screens/pocketmoneyrec_screen.dart';
import 'package:bpibs/ui/Screens/profile_screen.dart';
import 'package:bpibs/ui/Screens/spppaymentrec_screen.dart';
import 'package:bpibs/ui/Screens/visitregisform_screen.dart';
import 'package:flutter/material.dart';
import 'package:bpibs/constants/const.dart';

import '../widgets/home_witget.dart';
import 'achievpointsrec_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> cardData = [
    {
      'text1': 'Pembayaran SPP',
      'text2': 'Juli 2022',
      'jumlah': 'Rp 4,900,000',
      'footer1': 'Pembayaran SPP selanjutnya',
      'footer2': 'Agustus 2022',
      'status': 'Lunas',
      'background': const Color.fromARGB(255, 255, 255, 255),
    },
    {
      'text1': 'Uang Saku',
      'text2': 'Total Saldo',
      'jumlah': 'Rp 900,000',
      'footer1': '2022-11-23',
      'footer2': '+ Rp 150,000.00',
      'background': const Color.fromARGB(255, 255, 255, 255),
    },
    {
      'text1': 'Poin Prestasi',
      'null': 'null',
      'jumlah': 'Total Poin : 245',
      'footer1': '2022-11-23',
      'poin': '+10',
      'background': const Color.fromARGB(255, 255, 255, 255),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 75,
        title: Text(
          'Portal Wali Siswa',
          style: basicTextStyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.popAndPushNamed(context, LoginScreen.id);
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 168,
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                            'https://avatars0.githubusercontent.com/u/33479836?v=4'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aisyah Syafa Atifah',
                              textAlign: TextAlign.left,
                              style: basicTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: bold,
                              ),
                            ),
                            Text(
                              'Lubaabah Bintu Haarits',
                              textAlign: TextAlign.left,
                              style: basicTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                            Text(
                              '10 IPA - Akhwat',
                              textAlign: TextAlign.left,
                              style: basicTextStyle.copyWith(
                                fontSize: 9,
                                fontWeight: light,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -50.0),
                child: SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: PageController(
                      initialPage: 0, // Set the initial page index
                      viewportFraction: 0.9, // Set the viewport fraction
                    ),
                    itemCount: cardData.length,
                    itemBuilder: (context, index) {
                      final data = cardData[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 4.0,
                          color: data['background'],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          data['text1'],
                                          style: basicTextStyle.copyWith(
                                            fontSize: 10,
                                            fontWeight: semiBold,
                                          ),
                                        ),
                                        if (data.containsKey('null'))
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        if (data.containsKey('text2'))
                                          Text(
                                            data['text2'],
                                            style: basicTextStyle.copyWith(
                                              fontSize: 10,
                                              fontWeight: light,
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data['jumlah'],
                                          style: basicTextStyle.copyWith(
                                            fontSize: 17,
                                            fontWeight: bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (data.containsKey('status'))
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 30),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 25, 221, 34),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        height: 15,
                                        width: 40,
                                        child: Text(
                                          data['status'],
                                          textAlign: TextAlign.center,
                                          style: basicTextStyle.copyWith(
                                            fontSize: 10,
                                            fontWeight: light,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 197, 194, 194),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['footer1'],
                                        style: basicTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: light,
                                        ),
                                      ),
                                      if (data.containsKey('footer2'))
                                        Text(
                                          data['footer2'],
                                          style: basicTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: light,
                                          ),
                                        ),
                                      if (data.containsKey('poin'))
                                        Text(
                                          'Poin : ${data['poin']}',
                                          style: basicTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: light,
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, ProfileScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/profileh.png',
                      text: 'Profile',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, SPPPaymentrecScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/paymenth.png',
                      text: 'SPP & Pembayaran',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, PocketmoneyrecScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/waleth.png',
                      text: 'Uang Saku',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, ArchievpointsrecScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/archivementh.png',
                      text: 'Point Prestasi',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const CustomCard(
                      imagePath: 'assets/icon/academixgradesh.png',
                      text: 'Nilai Akademik Diniah',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, PickupregisformScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/pickuph.png',
                      text: 'Daftar Penjemputan',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, VisitregisformScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/visith.png',
                      text: 'Daftar Kunjungan',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
