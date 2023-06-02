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
  const PickupregisformScreen({Key? key}) : super(key: key);

  @override
  State<PickupregisformScreen> createState() => _PickupregisformScreenState();
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

     String url = 
          'http://192.168.1.5/mybpibs-api/api/penjemputan_input.php';

          var request = http.MultipartRequest('POST', Uri.parse(url));


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
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Faiz athaya ramadhan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Periode kunjungan : Ahad,14 mei 2024'),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: backgroundCard1,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'Nama Penjemput (Mahrom)',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          namaPenjemputTextField(size),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'Tanggal Lahir',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          tanggalLahirTextField(size),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'Hubungan dengan siswa',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          hubSiswaTextField(size),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'No KTP',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              noKtpAwalTextField(size),
                              noKtpAkhirTextField(size),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'Alamat',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          alamatTextField(size),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'Alamat Tinggal',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          alamatTinggalTextField(size),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, bottom: 5, top: 10),
                            child: Text(
                              'No whatsapp',
                              style: basicTextStyle.copyWith(
                                fontSize: 13,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                          noWaTextField(size),
                          SizedBox(
                            height: 20,
                          ),
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
                          SizedBox(
                            height: 20,
                          ),
                          Center(child: kirimButton(size, context)),
                          SizedBox(
                            height: 20,
                          )
                        ],
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

  Widget namaPenjemputTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromARGB(
            255,
            138,
            134,
            134,
          ), // Change the color of the border here
          width: 1.0, // Change the width of the border here
        ),
        color: inputColor1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: namaPenjemputController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Nama Penjemput',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget tanggalLahirTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: MediaQuery.of(context).size.width,
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
        child: GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: AbsorbPointer(
            child: TextField(
              controller: tanggalLahirController,
              maxLines: 1,
              cursorColor: const Color.fromARGB(179, 0, 0, 0),
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.inter(
                fontSize: 14.0,
                color: const Color.fromARGB(179, 0, 0, 0),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Tanggal Lahir',
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

  Widget hubSiswaTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromARGB(
            255,
            138,
            134,
            134,
          ), // Change the color of the border here
          width: 1.0, // Change the width of the border here
        ),
        color: inputColor1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: hubSiswaController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Hubungan',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget noKtpAwalTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: size.width / 2.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromARGB(
            255,
            138,
            134,
            134,
          ),
          width: 1.0,
        ),
        color: inputColor1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: noKtpAwalController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Awal',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget noKtpAkhirTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: size.width / 2.3,
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
          controller: noKtpAkhirController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Akhir',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget alamatTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: MediaQuery.of(context).size.width,
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
          controller: alamatController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Alamat',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget alamatTinggalTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: MediaQuery.of(context).size.width,
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
          controller: alamatTinggalController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Alamat Tinggal',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget noWaTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 17,
      width: MediaQuery.of(context).size.width,
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
          controller: noWaController,
          maxLines: 1,
          cursorColor: const Color.fromARGB(179, 0, 0, 0),
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            color: const Color.fromARGB(179, 0, 0, 0),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'No Whatsapp',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: inputColor4,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget kirimButton(Size size, BuildContext context) {
    return GestureDetector(
      onTap: () {
        uploadData();
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 16,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: buttonColor1,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    );
  }
}
