import 'dart:async';
import 'dart:convert';

import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:bpibs/ui/widgets/buildButton_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/const.dart';

import 'home_screen.dart';

class ChangepassScreen extends StatefulWidget {
  static const id = 'ChangepassScreen';

  const ChangepassScreen({Key? key}) : super(key: key);
  @override
  ChangepassScreenState createState() => ChangepassScreenState();
}

class ChangepassScreenState extends State<ChangepassScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch =
          passwordController.text == confirmPasswordController.text;
    });
  }

  Future<void> _changePassword() async {
    String newPassword = passwordController.text;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userProfile = prefs.getString('userProfile');
      if (userProfile != null) {
        Map<String, dynamic> profile = json.decode(userProfile);
        String nis = profile['nis'];

        final response = await http.post(
          Uri.parse(api),
          body: {
            'action': 'update_password',
            'nis': nis,
            'new_password': newPassword,
          },
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            // Data berhasil disimpan, tampilkan dialog sukses
            showSuccessDialog(context, jsonResponse['message'], () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(HomeScreen.id);
            });
          } else {
            // Gagal menambahkan data
            showErrorDialog(context, jsonResponse['message'], () {
              Navigator.of(context).pop();
            });
          }
        } else {
          // Terjadi masalah pada server
          showErrorDialog(
              context, 'Terjadi masalah pada server saat mengubah password.',
              () {
            Navigator.of(context).pop();
          });
        }
      }
    } catch (e) {
      // Terjadi masalah pada koneksi
      showErrorDialog(
          context, 'Terjadi masalah pada koneksi saat mengubah password.', () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          'Ubah Password',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            'Set new password',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Your new password must be different to previously used passwords',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            alignment: Alignment.center,
            height: size.height / 16,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: inputColor1,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFF757171),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      maxLines: 1,
                      cursorColor: const Color.fromARGB(179, 0, 0, 0),
                      obscureText: true,
                      style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: const Color.fromARGB(179, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: const Color(0xFF757171),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: size.height / 16,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: inputColor1,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF757171),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
                          controller: confirmPasswordController,
                          maxLines: 1,
                          cursorColor: const Color.fromARGB(179, 0, 0, 0),
                          obscureText: true,
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: const Color.fromARGB(179, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 14.0,
                              color: const Color(0xFF757171),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => _validatePasswords(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (!_passwordsMatch)
                const Text(
                  'Passwords do not match',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          BuildButton(
            width: 300,
            height: size.height / 16,
            onTap: () async {
              await _changePassword();
            },
            label: 'Simpan',
          ),
        ],
      ),
    );
  }
}
