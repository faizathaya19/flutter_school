import 'dart:convert';

import 'package:bpibs/constants/const.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgetpass_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nisController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

void _login() async {
    String url = 'https://shoesez.000webhostapp.com/login.php';

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    Map<String, String> body = {
      'nis': nisController.text,
      'password': passwordController.text,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );

    try {
      var response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          Navigator.pop(context); // Close the loading dialog

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: Text('Login successful'),
              );
            },
          );

          // Delay for 3 seconds
          await Future.delayed(Duration(seconds: 3));

          Navigator.pop(context); // Close the "Login successful" dialog
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        } else {
          Navigator.pop(context); // Close the loading dialog

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(data['message']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        Navigator.pop(context); // Close the loading dialog

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Failed to connect to the server. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print('Exception: $e');
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
                              nisTextField(size, nisController),
                              const SizedBox(
                                height: 20,
                              ),
                              passwordTextField(size, passwordController),
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

  Widget nisTextField(
      Size size, TextEditingController nisController) {
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
            const Icon(
              Icons.account_circle_outlined,
              color: Color.fromRGBO(102, 102, 102, 0.8),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: nisController,
                maxLines: 1,
                cursorColor: const Color.fromARGB(179, 0, 0, 0),
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: const Color.fromARGB(179, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    hintText: 'nis',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.0,
                      color: inputColor4,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordTextField(
      Size size, TextEditingController passwordController) {
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
        onPressed: _login,
        child: const Text(
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
