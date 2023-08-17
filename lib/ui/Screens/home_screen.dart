import 'dart:convert';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/screens/notification_activity_pickup.dart';
import 'package:bpibs/ui/screens/notification_activity_visit.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
                  'text1': 'Poin Prestasi',
                  'text2': '${poinPrestasi['jumlah']}',
                },
                {
                  'text1': 'Uang Saku',
                  'text2': '${uangSaku['jumlah']}',
                },
                {
                  'text1': 'Pembayaran SPP',
                  'text2': '${pembayaranSPP['text2']}',
                  'status': '${pembayaranSPP['status']}',
                },
              ];
              isLoading = false;
            });
          } else {
            showErrorDialog(context, jsonResponse['message'], () {
              Navigator.of(context).pop();
            });
          }
        } else {
          showErrorDialog(context, 'Terjadi masalah pada server.', () {
            Navigator.of(context).pop();
          });
        }
      } catch (e) {
        showErrorDialog(context, 'Terjadi masalah pada koneksi.', () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 242, 236),
      drawer: drawerWidget(context), // Your custom drawer widget here
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/header.png'), // Replace 'your_background_image.png' with your actual image path
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Builder(
                            builder: (context) => IconButton(
                              icon: const Material(
                                elevation:
                                    4.0, // Set the elevation value as desired
                                shape: CircleBorder(),
                                clipBehavior: Clip.hardEdge,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      4.0), // Add padding of 10 around the CircleAvatar
                                  child: CircleAvatar(
                                    radius:
                                        100, // Set the radius to 25 for a height and width of 50
                                    backgroundImage:
                                        AssetImage('assets/icon/menu.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: isLoading ? 0 : 50,
                          width: isLoading ? 0 : 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(isLoading ? 0 : 32),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://avatars0.githubusercontent.com/u/33479836?v=4',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${profile['nama_lengkap']}',
                        textAlign: TextAlign.left,
                        style: basicTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile['asrama']}',
                        textAlign: TextAlign.left,
                        style: basicTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -25.0),
                child: AnimatedOpacity(
                  opacity: isLoading ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      cardData.length,
                      (index) => Expanded(
                        flex: 1,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 9.1,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      cardData[index].containsKey('status')
                                          ? 11.0
                                          : 19.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        cardData[index]['text1'],
                                        style: basicTextStyle.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      ),
                                      Text(
                                        cardData[index]['text2'] ?? '',
                                        style: basicTextStyle.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (cardData[index].containsKey('status'))
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 16, 196, 16),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cardData[index]['status'] ?? '',
                                          textAlign: TextAlign.center,
                                          style: basicTextStyle.copyWith(
                                            fontSize: 10,
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
                      ),
                    ),
                  ),
                ),
              ),
              Pickupnow(),
              Visitnow(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Text(
                      'Fitur',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0, // Horizontal spacing between the buttons
                    runSpacing:
                        8.0, // Vertical spacing between the rows of buttons
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ProfileScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/profileh.png',
                          text: 'Profil',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SPPPaymentrecScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/paymenth.png',
                          text: 'SPP & Pembayaran',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, PocketmoneyrecScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/waleth.png',
                          text: 'Uang Saku',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ArchievpointsrecScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/archivementh.png',
                          text: 'Point Prestasi',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, RaportsScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/academixgradesh.png',
                          text: 'Nilai Akademik Diniah',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, PickupregisformScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/pickuph.png',
                          text: 'Daftar Penjemputan',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, VisitregisformScreen.id);
                        },
                        child: CustomButton(
                          imagePath: 'assets/icon/visith.png',
                          text: 'Daftar Kunjungan',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Berita Terbaru',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    News(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final String imagePath;
  final String text;

  CustomButton({required this.imagePath, required this.text});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Add a delay before showing the button to create the appear effect
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _isVisible ? 1.0 : 0.0,
      child: Container(
        height: 110,
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
              elevation: 3, // Adjust the elevation value as needed
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 37,
                backgroundColor: backgroundCard1,
                child: Image.asset(
                  widget.imagePath,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: basicTextStyle.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class News extends StatelessWidget {
  News({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> newsData = [
    {
      'imagePath': 'assets/parenting-wali-siswa.png',
      'title': 'Parenting Wali Siswa',
      'content':
          'Kegiatan seminar parenting bagi para wali siswa untuk menjalin ikatan yang kuat antara sekolah dengan wali siswa dan juga mensinergikan kegiatan proses pembelajaran.',
      'link': 'https://www.bpibs.sch.id/detail/parenting-wali-siswa',
    },
    {
      'imagePath': 'assets/20200922_sma-bpibs-goes-to-campus-2019.jpg',
      'title': 'SMA BPIBS Goes To Campus 2019',
      'content':
          'Goes to campus adalah suatu kegiatan yang diadakan di sekolah dimana para siswa akan dibawa ke berbagai perguruan tinggi negeri selama satu hari atau lebih. Dimana adanya kegiatan ini, para siswa',
      'link': 'https://www.bpibs.sch.id/detail/sma-bpibs-goes-to-campus-2019',
    },

    // Add more dummy data here...
  ];

  String _truncateString(String text) {
    const int maxChars = 100;
    if (text.length > maxChars) {
      return '${text.substring(0, maxChars)}.... read more';
    }
    return text;
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView:
            false, // Set this to false to open in the external browser
        universalLinksOnly: true, // Optional parameter for deep links
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newsData.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _launchURL(newsData[index]
                ['link']); // Call the method to open the web link
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      newsData[index]['imagePath'],
                      fit: BoxFit.contain,
                      // loadingBuilder: (context, child, loadingProgress) {
                      //   if (loadingProgress == null) return child;
                      //   return CircularProgressIndicator();
                      // },
                      // errorBuilder: (context, error, stackTrace) {
                      //   return Icon(Icons
                      //       .error); // or any other error indicator you want
                      // },
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsData[index]['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _truncateString(newsData[index]['content']),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                  color: Color.fromARGB(255, 0, 0, 0),
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
          title: const Text('Ubah Password'),
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
