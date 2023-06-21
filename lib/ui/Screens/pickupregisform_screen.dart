import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/const.dart';
import 'home_screen.dart';

class PickupregisformScreen extends StatefulWidget {
  static const id = 'PickupregisformScreen';

  @override
  _PickupregisformScreenState createState() => _PickupregisformScreenState();
}

class _PickupregisformScreenState extends State<PickupregisformScreen> {
  final TextEditingController namaPenjemputController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController hubSiswaController = TextEditingController();
  final TextEditingController noKtpAwalController = TextEditingController();
  final TextEditingController noKtpAkhirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController alamatTinggalController = TextEditingController();
  final TextEditingController noWaController = TextEditingController();

  bool isLoading = false;
  XFile? imageFile;

  Future<void> uploadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var nis;

      // Mengambil nis dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      nis = prefs.getString('nis');

      String url = 'http://192.168.1.2/mybpibs-api/api/api.php';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['action'] = 'penjemputan_input';
      request.fields['nis'] = nis!;
      request.fields['nama_penjemput'] = namaPenjemputController.text;
      request.fields['tanggal_lahir'] = tanggalLahirController.text;
      request.fields['hubungan_dengan_siswa'] = hubSiswaController.text;
      request.fields['no_ktp_awal'] = noKtpAwalController.text;
      request.fields['no_ktp_akhir'] = noKtpAkhirController.text;
      request.fields['alamat_sesuai_ktp'] = alamatController.text;
      request.fields['alamat_tinggal'] = alamatTinggalController.text;
      request.fields['no_whatsapp_penjemput'] = noWaController.text;

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile!.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        if (jsonResponse['status'] == 'success') {
          // Berhasil menambahkan data
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text('Success'),
              content: Text(jsonResponse['message']),
            ),
          );

          // Menunggu selama 5 detik sebelum pindah ke layar beranda
          Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(HomeScreen.id);
          });
        } else {
          // Gagal menambahkan data
          showErrorDialog(jsonResponse['message']);
        }
      } else {
        // Terjadi masalah pada server
        showErrorDialog('Terjadi masalah pada server.');
      }
    } catch (e) {
      // Terjadi masalah pada koneksi
      showErrorDialog('Terjadi masalah pada koneksi.');
    }

    setState(() {
      isLoading = false;
    });
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

  void chooseImage() async {
    final picker = ImagePicker();
    var pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor1,
      appBar: AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          },
        ),
        title: const Text(
          'Form Pendaftaran Penjemputan Wali Siswa',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faiz athaya ramadhan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Periode kunjungan : Ahad,14 mei 2024'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormTextField(
                    controller: namaPenjemputController,
                    labelText: 'Nama Penjemput (Mahrom)',
                    size: size,
                  ),
                  FormTextField(
                    controller: tanggalLahirController,
                    labelText: 'Tanggal Lahir',
                    size: size,
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                  ),
                  FormTextField(
                    controller: hubSiswaController,
                    labelText: 'Hubungan dengan siswa',
                    size: size,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormTextField(
                          controller: noKtpAwalController,
                          labelText: 'No KTP (Awal)',
                          size: Size(size.width * 0.5, size.height),
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: FormTextField(
                          controller: noKtpAkhirController,
                          labelText: 'No KTP (Akhir)',
                          size: Size(size.width * 0.5, size.height),
                        ),
                      ),
                    ],
                  ),
                  FormTextField(
                    controller: alamatController,
                    labelText: 'Alamat',
                    size: size,
                    maxLines: null,
                  ),
                  FormTextField(
                    controller: alamatTinggalController,
                    labelText: 'Alamat Tinggal',
                    size: size,
                    maxLines: null,
                  ),
                  FormTextField(
                    controller: noWaController,
                    labelText: 'No WhatsApp',
                    size: size,
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: chooseImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: inputColor1,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                File(imageFile!.path),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 40.0,
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        uploadData();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: size.height / 16,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: buttonColor1,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Kirim',
                                style: GoogleFonts.inter(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        tanggalLahirController.text = picked.toString().split(' ')[0];
      });
    }
  }
}

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Size size;
  final Function()? onTap;
  final bool readOnly;
  final int? maxLines;

  const FormTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.size,
    this.onTap,
    this.readOnly = false,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: basicTextStyle.copyWith(
              fontSize: 13,
              fontWeight: bold,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: const Color.fromARGB(255, 138, 134, 134),
                width: 1.0,
              ),
              color: inputColor1,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                cursorColor: const Color.fromARGB(179, 0, 0, 0),
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: const Color.fromARGB(179, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                ),
                readOnly: readOnly,
                onTap: onTap,
                decoration: InputDecoration(
                  hintText: labelText,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: inputColor4,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
