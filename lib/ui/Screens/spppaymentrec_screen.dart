import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants/const.dart';
import 'home_screen.dart';

class SPPPaymentrecScreen extends StatefulWidget {
  static const id = 'SPPPaymentrecScreen';
  const SPPPaymentrecScreen({Key? key}) : super(key: key);

  @override
  _SPPPaymentrecScreenState createState() => _SPPPaymentrecScreenState();
}

class _SPPPaymentrecScreenState extends State<SPPPaymentrecScreen> {
  String currentYear = DateFormat('yyyy').format(DateTime.now());
  List<dynamic> pembayaranSPP = []; // Data pembayaran SPP

  @override
  void initState() {
    super.initState();
    _fetchPembayaranSPP();
  }

  Future<void> _fetchPembayaranSPP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userProfile = prefs.getString('userProfile');
      if (userProfile != null) {
        Map<String, dynamic> profile = json.decode(userProfile);
        String nis = profile['nis'];

        final response = await http.post(
          Uri.parse(
              'http://192.168.1.5/mybpibs-api/api/api.php'), // Ganti URL dengan alamat api.php
          body: {'action': 'pembayaran_spp_get', 'nis': nis},
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            setState(() {
              pembayaranSPP = jsonResponse['pembayaranSPP'];
            });
          } else {
            showErrorDialog(jsonResponse['message']);
          }
        } else {
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
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
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
    String adjustedYear = currentYear;
    int currentMonth = DateTime.now().month;
    if (currentMonth >= 7 && currentMonth <= 12) {
      int currentYearNumeric = int.parse(currentYear);
      adjustedYear = (currentYearNumeric - 1).toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100, // Set a specific height for the toolbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Rekap Pembayaran SPP',
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
          children: [
            for (int i = 0; i < pembayaranSPP.length; i += 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (i < pembayaranSPP.length)
                    _buildCustomCard(pembayaranSPP[i], adjustedYear),
                  if (i + 1 < pembayaranSPP.length)
                    _buildCustomCard(pembayaranSPP[i + 1], adjustedYear),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCard(dynamic data, String adjustedYear) {
    String adjustedYearItem = adjustedYear;
    if (data['bulan'] == 'Juli' ||
        data['bulan'] == 'Agustus' ||
        data['bulan'] == 'September' ||
        data['bulan'] == 'Oktober' ||
        data['bulan'] == 'November' ||
        data['bulan'] == 'Desember') {
      int currentYearNumeric = int.parse(adjustedYear);
      adjustedYearItem = (currentYearNumeric - 1).toString();
    }

    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    int biaya =
        int.parse(data['biaya']); // Mengkonversi harga menjadi bilangan bulat

    return data['status'] == 'Lunas'
        ? CustomCard1(
            textharga: currencyFormat.format(biaya),
            texttanggal: '${data['bulan']} $adjustedYearItem',
            textstatus: data['status'],
          )
        : CustomCard2(
            textharga: currencyFormat.format(biaya),
            texttanggal: '${data['bulan']} $adjustedYearItem',
            textstatus: data['status'],
          );
  }
}

class CustomCard1 extends StatelessWidget {
  final String textharga;
  final String texttanggal;
  final String textstatus;

  const CustomCard1({
    super.key,
    required this.textharga,
    required this.texttanggal,
    required this.textstatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 160,
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textharga,
                    style: basicTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    texttanggal,
                    style: basicTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 16, 196, 16),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textstatus,
                        style: basicTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCard2 extends StatelessWidget {
  final String textharga;
  final String texttanggal;
  final String textstatus;

  const CustomCard2({
    super.key,
    required this.textharga,
    required this.texttanggal,
    required this.textstatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 160,
        width: 160,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textharga,
                    style: basicTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    texttanggal,
                    style: basicTextStyle.copyWith(
                      fontSize: 13,
                      fontWeight: light,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 219, 31, 31),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textstatus,
                        style: basicTextStyle.copyWith(
                          fontSize: 15,
                          fontWeight: bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
