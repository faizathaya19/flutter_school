import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class PocketmoneyrecScreen extends StatefulWidget {
  static const id = 'PocketmoneyrecScreen';
  const PocketmoneyrecScreen({Key? key});

  @override
  State<PocketmoneyrecScreen> createState() => _PocketmoneyrecScreenState();
}

class _PocketmoneyrecScreenState extends State<PocketmoneyrecScreen> {
  List<dynamic> uangSaku = [];
  String? namaLengkap;
  int totalSaldo = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchuangSaku();
  }

  Future<void> fetchuangSaku() async {
    // Ambil NIS dari shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString('userProfile');
    if (userProfile != null) {
      Map<String, dynamic> profile = json.decode(userProfile);
      String nis = profile['nis'];
      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.5/mybpibs-api/api/uang_saku_get.php'),
          body: {
            'nis': nis,
          },
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            setState(() {
              uangSaku = jsonResponse['uangSaku'];
              namaLengkap = jsonResponse['uangSaku'][0]['nama_lengkap'];
              totalSaldo = calculateTotalSaldo(jsonResponse['uangSaku']);
              isLoading = false;
            });
          } else {
            showErrorDialog(jsonResponse['message']);
            isLoading = false;
          }
        } else {
          showErrorDialog('Terjadi masalah pada server.');
          isLoading = false;
        }
      } catch (e) {
        showErrorDialog('Terjadi masalah pada koneksi.');
        isLoading = false;
      }
    }
  }

  int calculateTotalSaldo(List<dynamic> saldoList) {
    int total = 0;
    for (var saldo in saldoList) {
      int debit = int.parse(saldo['debit']);
      int kredit = int.parse(saldo['kredit']);
      total += debit - kredit;
    }
    return total;
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
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
          'Rekap Uang Saku',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.5),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            namaLengkap ?? '', // nama lengkap
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              'Total Saldo : ${currencyFormat.format(totalSaldo)}'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: uangSaku.length,
                    itemBuilder: (context, index) {
                      return _builduangSakuItem(
                          uangSaku[index], currencyFormat);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _builduangSakuItem(
      Map<String, dynamic> saldo, NumberFormat currencyFormat) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 234, 237, 240),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saldo['keterangan'],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(saldo['created_at']),
                  saldo['debit'] != '0'
                      ? Text(
                          '+ ${currencyFormat.format(int.parse(saldo['debit']))}')
                      : Text(
                          '- ${currencyFormat.format(int.parse(saldo['kredit']))}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
