import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
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
          Uri.parse(api), // Ganti URL dengan alamat api.php
          body: {'action': 'uang_saku_get', 'nis': nis},
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
            showErrorDialog(context, jsonResponse['message'], () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(HomeScreen.id);
            });
            isLoading = false;
          }
        } else {
          showErrorDialog(context, 'Terjadi masalah pada server.', () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(HomeScreen.id);
          });
          isLoading = false;
        }
      } catch (e) {
        showErrorDialog(context, 'Terjadi masalah pada koneksi.', () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(HomeScreen.id);
        });
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
          color: Colors.black,
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
          ? const Center(
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
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            namaLengkap ?? '', // nama lengkap
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            'Total Saldo : ${currencyFormat.format(totalSaldo)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
          color: backgroundCard1,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Warna shadow
              spreadRadius: 2, // Jarak shadow ke kontainer
              blurRadius: 5, // Besar bayangan blur
              offset: Offset(0, 3), // Posisi offset dari bayangan (x, y)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saldo['keterangan'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 3),
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
