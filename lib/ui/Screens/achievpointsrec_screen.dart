import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../constants/const.dart';
import 'home_screen.dart';

class ArchievpointsrecScreen extends StatefulWidget {
  static const id = 'ArchievpointsrecScreen';
  const ArchievpointsrecScreen({Key? key});

  @override
  State<ArchievpointsrecScreen> createState() => _ArchievpointsrecScreenState();
}

class _ArchievpointsrecScreenState extends State<ArchievpointsrecScreen> {
  List<dynamic> poinPrestasi = [];
  String? namaLengkap;
  int totalPoin = 0;

  @override
  void initState() {
    super.initState();
    fetchPoinPrestasi();
  }

  Future<void> fetchPoinPrestasi() async {
    // Ambil NIS dari shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString('userProfile');
    if (userProfile != null) {
      Map<String, dynamic> profile = json.decode(userProfile);
      String nis = profile['nis'];
      try {
        final response = await http.post(
          Uri.parse('https://shoesez.000webhostapp.com/poin_prestasi_get.php'),
          body: {
            'nis': nis,
          },
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            setState(() {
              poinPrestasi = jsonResponse['poinPrestasi'];
              namaLengkap = jsonResponse['poinPrestasi'][0]['nama_lengkap'];
              totalPoin = calculateTotalPoin(jsonResponse['poinPrestasi']);
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

  int calculateTotalPoin(List<dynamic> poinList) {
    int total = 0;
    for (var poin in poinList) {
      int penambahan = int.parse(poin['penambahan']);
      int pengurangan = int.parse(poin['pengurangan']);
      total += penambahan - pengurangan;
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
        toolbarHeight: 100, // Atur tinggi khusus untuk toolbar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Rekap Poin Prestasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
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
                    Text('Total Poin : $totalPoin'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: poinPrestasi.length,
              itemBuilder: (context, index) {
                return _buildPoinPrestasiItem(poinPrestasi[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoinPrestasiItem(Map<String, dynamic> poin) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 100,
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
                poin['keterangan'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(poin['created_at']),
                  poin['penambahan'] != '0'
                      ? Text('+ ${poin['penambahan']}')
                      : Text('- ${poin['pengurangan']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
