import 'dart:convert';

import 'package:bpibs/services/api_service.dart';
import 'package:bpibs/ui/widgets/DialogShow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/const.dart';
import 'home_screen.dart';
import 'forgetpass_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nisController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool isLoading = false;

  Future<void> loginUser(String nis, String password) async {
    if (nis.isEmpty || password.isEmpty) {
      showErrorDialog(context, 'Username atau password belum diinput.', () {
        Navigator.of(context).pop();
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(api),
        body: {
          'action': 'login',
          'nis': nis,
          'password': password,
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userProfile', json.encode(jsonResponse['profile']));
          // Menyimpan nis di SharedPreferences
          prefs.setString('nis', nis);
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        } else {
          showErrorDialog(context, jsonResponse['message'], () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showErrorDialog(context, 'Terjadi masalah pada server.', () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, 'Terjadi masalah pada koneksi.', () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20.0,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 90,
                              ),
                              logo(size.height / 5, size.height / 3),
                              const SizedBox(
                                height: 20,
                              ),
                              textHeader(size),
                              const SizedBox(
                                height: 62,
                              ),
                              CustomTextField(
                                size: size,
                                controller: nisController,
                                hintText: 'nis',
                                icon: Icons.account_circle_outlined,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomTextField(
                                size: size,
                                controller: passwordController,
                                hintText: 'password',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _isPasswordHidden,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              signInButton(size, context),
                              const SizedBox(
                                height: 20,
                              ),
                              // footer(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/Logo.png',
      height: height_,
      width: width_,
    );
  }

  Widget textHeader(Size size) {
    return const Column(
      children: [
        Text(
          "My-BPIBS",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Portal Wali Siswa",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget footer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ForgetpassScreen.id);
            },
            child: const Text(
              'Forget password?',
            ),
          ),
        ],
      ),
    );
  }

  Widget signInButton(Size size, BuildContext context) {
    return Container(
      width: 300,
      height: size.height / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: buttonColor1,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position [horizontal, vertical]
          ),
        ],
      ),
      child: TextButton(
        onPressed: isLoading
            ? null
            : () {
                loginUser(
                  nisController.text,
                  passwordController.text,
                );
              },
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.size,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(
          color: Colors.black, // You can change the border color here
          width: 1.0, // You can adjust the border width here
        ),
        color: inputColor1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: basicTextColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 1,
                cursorColor: const Color.fromARGB(179, 0, 0, 0),
                keyboardType: TextInputType.emailAddress,
                obscureText: obscureText,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: basicTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
