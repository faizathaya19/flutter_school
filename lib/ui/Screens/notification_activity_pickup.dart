import 'package:bpibs/constants/const.dart';
import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/screens/home_screen.dart';
import 'package:bpibs/ui/screens/pickupregisform_screen.dart';
import 'package:bpibs/ui/widgets/BuildButton_Widget.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Pickupnow extends StatefulWidget {
  Pickupnow({Key? key}) : super(key: key);

  @override
  State<Pickupnow> createState() => _PickupnowState();
}

class _PickupnowState extends State<Pickupnow> {
  List<Map<String, dynamic>> pickupList = [];
  List<Map<String, dynamic>> dateList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPickupList();
    _fetchDateActList();
  }

  Future<void> _changePickupStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    try {
      String responseMessage = await ApiService.changePickupStatus(nis!);

      showSuccessDialog(context, responseMessage, () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(PickupregisformScreen.id);
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

  Future<void> _fetchPickupList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nis = prefs.getString('nis');

    List<Map<String, dynamic>> list = await ApiService.fetchPickupList(nis);
    setState(() {
      pickupList = list;
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
    bool shouldDisplay = pickupList.isNotEmpty && pickupList[0]['status'] != 0;

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
        onTap: _showPickupDetails,
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
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10.0), // You can adjust the radius value as per your preference
                                child: Image.network(
                                  '$apiimgact${pickupList.isNotEmpty ? pickupList[0]['image'] : ''}',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
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
                                  const Text(
                                    'Penjemputan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    pickupList.isNotEmpty
                                        ? pickupList[0]['nama_penjemput'] ?? ''
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

  void _showPickupDetails() {
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
              Text('Penjemputan Detail'),
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
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    '$apiimgact${pickupList.isNotEmpty ? pickupList[0]['image'] : ''}',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                  'Tanggal Penjemputan: ${dateList.isNotEmpty ? dateList[0]['tanggal'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'Penjemputan: ${pickupList.isNotEmpty ? pickupList[0]['nama_penjemput'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'No KTP: ${pickupList.isNotEmpty ? pickupList[0]['no_ktp'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'Tanggal Lahir: ${pickupList.isNotEmpty ? pickupList[0]['tanggal_lahir'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'Hubungan Dengan Siswa: ${pickupList.isNotEmpty ? pickupList[0]['hubungan_dengan_siswa'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'Alamat Tinggal: ${pickupList.isNotEmpty ? pickupList[0]['alamat_sesuai_ktp'] ?? '' : ''}'),
              SizedBox(height: 8),
              Text(
                  'No Whatsapp: ${pickupList.isNotEmpty ? pickupList[0]['no_whatsapp_penjemput'] ?? '' : ''}'),
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
                        _changePickupStatus();
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
