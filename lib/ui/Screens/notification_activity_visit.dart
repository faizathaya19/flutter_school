import 'package:bpibs/constants/const.dart';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/screens/home_screen.dart';
import 'package:bpibs/ui/screens/visitregisform_screen.dart';
import 'package:bpibs/ui/widgets/BuildButton_Widget.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Visitnow extends StatefulWidget {
  Visitnow({Key? key}) : super(key: key);

  @override
  State<Visitnow> createState() => _VisitnowState();
}

class _VisitnowState extends State<Visitnow> {
  List<Map<String, dynamic>> visitList = [];
  List<Map<String, dynamic>> dateList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVisitList();
    _fetchDateActList();
  }

  Future<void> _changeVisitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    try {
      String responseMessage = await ApiService.changeVisitStatus(nis!);

      showSuccessDialog(context, responseMessage, () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(VisitregisformScreen.id);
      });
    } catch (e) {
      String errorMessage;
      if (e is http.ClientException) {
        errorMessage = 'Terjadi masalah pada server.';
      } else {
        errorMessage = 'Ubah: $e';
      }

      showErrorDialog(context, errorMessage, () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(HomeScreen.id);
      });
    }
  }

  Future<void> _fetchVisitList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    List<Map<String, dynamic>> list = await ApiService.fetchVisitList(nis);
    setState(() {
      visitList = list;
      isLoading = false;
    });
  }

  Future<void> _fetchDateActList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    List<Map<String, dynamic>> list = await ApiService.fetchDateActList(nis);
    setState(() {
      dateList = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool shouldDisplay = visitList.isNotEmpty && visitList[0]['status'] != 0;

    if (!shouldDisplay) {
      // Return an empty SizedBox if you want to hide the widget completely
      // You can also return a message or an alternative widget here
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
        left: 8,
        bottom: 20,
      ),
      child: GestureDetector(
        onTap: _showVisitDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                right: 8,
                left: 8,
                bottom: 8,
              ),
              child: Text(
                'Aktivitas',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Penjengukan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    visitList.isNotEmpty
                                        ? visitList[0]['lokasi_kunjungan'] ?? ''
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    dateList.isNotEmpty
                                        ? dateList[0]['tanggal'] ?? ''
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
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
      ),
    );
  }

  void _showVisitDetails() {
    final Size size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Column(
            children: [
              Text('Kunjungan Detail'),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 25),
              Text(
                  'Tanggal Kunjungan: ${dateList.isNotEmpty ? dateList[0]['tanggal'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'Lokasi Kunjungan: ${visitList.isNotEmpty ? visitList[0]['lokasi_kunjungan'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'Waktu Kunjungan: ${visitList.isNotEmpty ? visitList[0]['waktu_kunjungan'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'No Whatsapp: ${visitList.isNotEmpty ? visitList[0]['no_whatsapp'] ?? '' : ''}'),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Untuk mengatur jarak antara tombol
                children: [
                  BuildButton(
                    width: size.width / 3, // Mengatur lebar tombol
                    height: size.height / 16,
                    label: 'Close',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  BuildButton(
                      width: size.width / 3, // Mengatur lebar tombol
                      height: size.height / 16,
                      label: 'Ubah',
                      onTap: () {
                        _changeVisitStatus();
                      }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
