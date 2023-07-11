import 'dart:convert';
import 'package:bpibs/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'achievpointsrec_screen.dart';
import 'changepass_screen.dart';
import 'information_screen.dart';
import 'login_screen.dart';
import 'pickupregisform_screen.dart';
import 'pocketmoneyrec_screen.dart';
import 'profile_screen.dart';
import 'raports_screen.dart';
import 'spppaymentrec_screen.dart';
import 'suggestionsandcritics_screen.dart';
import 'visitregisform_screen.dart';
import '../../constants/const.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> profile = {};
  Map<String, dynamic> homeData = {};
  List<Map<String, dynamic>> cardData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    final prefs = await SharedPreferences.getInstance();
    final userProfile = prefs.getString('userProfile');
    final nis = prefs.getString('nis');
    String apiUrl = api;
    final requestData = {
      'action': 'data_get_home',
      'nis': nis ?? '',
    };

    if (userProfile != null) {
      setState(() {
        profile = json.decode(userProfile);
        isLoading = false;
      });
      try {
        final response = await http.post(Uri.parse(apiUrl), body: requestData);

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            final decodedResponse = json.decode(response.body);

            final pembayaranSPP = decodedResponse['pembayaranSPP'];
            final uangSaku = decodedResponse['uangSaku'];
            final poinPrestasi = decodedResponse['poinPrestasi'];
            setState(() {
              homeData = decodedResponse;
              cardData = [
                {
                  'text1': 'Pembayaran SPP',
                  'text2': '${pembayaranSPP['text2']}',
                  'jumlah': '${pembayaranSPP['jumlah']}',
                  'footer1': 'Pembayaran SPP selanjutnya',
                  'footer2': '${pembayaranSPP['footer2']}',
                  'status': '${pembayaranSPP['status']}',
                },
                {
                  'text1': 'Uang Saku',
                  'text2': 'Total Saldo',
                  'jumlah': '${uangSaku['jumlah']}',
                  'footer1': '${uangSaku['footer1']}',
                  'footer2': '${uangSaku['footer2']}',
                },
                {
                  'text1': 'Poin Prestasi',
                  'null': 'null',
                  'jumlah': 'Total Poin : ${poinPrestasi['jumlah']}',
                  'footer1': '${poinPrestasi['footer1']}',
                  'poin': '${poinPrestasi['poin']}',
                },
              ];
              isLoading = false;
            });
          } else {
            showErrorDialog(jsonResponse['message']);
          }
        } else {
          showErrorDialog('Terjadi masalah pada server.');
        }
      } catch (e) {
        showErrorDialog('Terjadi masalah pada koneksi.');
      }
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
              Navigator.pushReplacementNamed(context, HomeScreen.id);
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
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 75,
        title: AnimatedOpacity(
          opacity: isLoading ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          child: Text(
            'Portal Wali Siswa',
            style: basicTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      drawer: drawerWidget(context),
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: isLoading ? 0 : 64,
                        width: isLoading ? 0 : 64,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(isLoading ? 0 : 32),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://avatars0.githubusercontent.com/u/33479836?v=4'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profile['nama_lengkap']}',
                              textAlign: TextAlign.left,
                              style: basicTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${profile['asrama']}',
                              textAlign: TextAlign.left,
                              style: basicTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${profile['kelas']} - ${profile['Jenis_kelamin']}',
                              textAlign: TextAlign.left,
                              style: basicTextStyle.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.w300,
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
                  child: AnimatedOpacity(
                    opacity: isLoading ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: PageView.builder(
                      controller: PageController(
                        initialPage: 0,
                        viewportFraction: 0.9,
                      ),
                      itemCount: cardData.length,
                      itemBuilder: (context, index) {
                        final data = cardData[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: CardWidget(data: data),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, ProfileScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/profileh.png',
                      text: 'Profil',
                    ),
                  ),
                  GestureDetector(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, PocketmoneyrecScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/waleth.png',
                      text: 'Uang Saku',
                    ),
                  ),
                  GestureDetector(
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, RaportsScreen.id);
                    },
                    child: const CustomCard(
                      imagePath: 'assets/icon/academixgradesh.png',
                      text: 'Nilai Akademik Diniah',
                    ),
                  ),
                  GestureDetector(
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
                  GestureDetector(
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

class CardWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const CardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 4.0,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        data['text1'],
                        style: basicTextStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data['jumlah'],
                        style: basicTextStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (data.containsKey('status'))
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        color: data['status'] == 'Lunas'
                            ? const Color.fromARGB(255, 16, 196, 16)
                            : const Color.fromARGB(255, 219, 31, 31),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 15,
                      width: 40,
                      child: Text(
                        data['status'],
                        textAlign: TextAlign.center,
                        style: basicTextStyle.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['footer1'],
                      style: basicTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    if (data.containsKey('footer2'))
                      Text(
                        data['footer2'],
                        style: basicTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    if (data.containsKey('poin'))
                      Text(
                        'Poin : ${data['poin']}',
                        style: basicTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
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
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String text;

  const CustomCard({
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: 180,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          color: const Color.fromARGB(255, 75, 77,
              202), // Change the background color of the Card to green
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors
                    .white, // Change the background color of the circle to white
                child: Image.asset(
                  imagePath,
                  width: 60, // Change the width of the asset to 60
                  height: 60, // Change the height of the asset to 60
                ),
              ),
              const SizedBox(height: 12),
              Text(
                text,
                style: primaryTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget drawerWidget(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: backgroundColor1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Logo.png',
                width: 150,
              ),
              const Text(
                'Bintang Pelajar Boarding School',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lightbulb),
          title: const Text('Saran dan Kritik'),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, SuggestionsAndCriticsScreen.id);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Informasi'),
          onTap: () {
            Navigator.pushReplacementNamed(context, InformationScreen.id);
          },
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Ubah Kata Sandi'),
          onTap: () {
            Navigator.pushReplacementNamed(context, ChangepassScreen.id);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Keluar'),
          onTap: () {
            Navigator.popAndPushNamed(context, LoginScreen.id);
          },
        ),
      ],
    ),
  );
}
