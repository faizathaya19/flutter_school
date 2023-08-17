import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../constants/const.dart';
import 'home_screen.dart';

class ArchievpointsrecScreen extends StatefulWidget {
  static const id = 'ArchievpointsrecScreen';
  const ArchievpointsrecScreen({Key? key}) : super(key: key);

  @override
  State<ArchievpointsrecScreen> createState() => _ArchievpointsrecScreenState();
}

class _ArchievpointsrecScreenState extends State<ArchievpointsrecScreen> {
  List<dynamic> poinPrestasi = [];
  String? namaLengkap;
  int totalPoin = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _fetchPoinPrestasi();
  }

  Future<void> _fetchPoinPrestasi() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString('userProfile');

    if (userProfile != null) {
      Map<String, dynamic> profile = json.decode(userProfile);
      String nis = profile['nis'];

      try {
        List<dynamic> poinPrestasiData =
            await ApiService.fetchPoinPrestasi(nis);

        setState(() {
          poinPrestasi = poinPrestasiData as List;
          namaLengkap = poinPrestasiData[0]['nama_lengkap'];
          totalPoin = calculateTotalPoin(poinPrestasiData as List);
          isLoading = false;
        });
      } catch (e) {
        String errorMessage;
        if (e is http.ClientException) {
          errorMessage = 'Terjadi Masalah Pada Server.';
        } else {
          errorMessage = 'Gagal Mengambil Data Raports: $e';
        }

        showErrorDialog(context, errorMessage, () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(HomeScreen.id);
        });
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
          color: Colors.black,
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
                            namaLengkap ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text('Total Poin : $totalPoin',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
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
                poin['keterangan'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
