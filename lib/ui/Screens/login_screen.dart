import 'dart:convert';

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
      showErrorDialog('Username atau password belum diinput.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2/mybpibs-api/api/api.php'),
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
          showErrorDialog(jsonResponse['message']);
        }
      } else {
        showErrorDialog('Terjadi masalah pada server.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Terjadi masalah pada koneksi.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
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
                              footer(context),
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
            ? CircularProgressIndicator()
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
        color: inputColor1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: const Color.fromRGBO(102, 102, 102, 0.8),
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
                  color: const Color.fromARGB(179, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.0,
                    color: inputColor4,
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
