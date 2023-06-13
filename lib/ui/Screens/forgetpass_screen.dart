import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/const.dart';
import 'login_screen.dart';

class ForgetpassScreen extends StatefulWidget {
  static const id = 'ForgetpassScreen';
  const ForgetpassScreen({super.key});

  @override
  State<ForgetpassScreen> createState() => _ForgetpassScreenState();
}

class _ForgetpassScreenState extends State<ForgetpassScreen> {
  TextEditingController usernameController = TextEditingController();

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
                              usernameTextField(size, usernameController),
                              const SizedBox(
                                height: 15,
                              ),
                              textInfo(size),
                              const SizedBox(
                                height: 50,
                              ),
                              signInButton(
                                size,
                                () {
                                  // LoginController().loginUser(context,
                                  //     emailController, passwordController);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              footer(context)
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

  Widget textInfo(Size size) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "kata sandi baru akan dikirimkan ke no hp yang terdaftar di aplikasi my.bpibs.id",
                style: secondaryTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget usernameTextField(
      Size size, TextEditingController usernameController) {
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
              color: Color(0xFF757171),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextField(
                controller: usernameController,
                maxLines: 1,
                cursorColor: const Color.fromARGB(179, 0, 0, 0),
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: const Color.fromARGB(179, 0, 0, 0),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                    hintText: 'Masukan username anda',
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

  Widget signInButton(Size size, VoidCallback onPressed) {
    return Container(
      height: size.height / 15,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0), color: buttonColor1),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          'Kirim',
          style: primaryTextStyle.copyWith(
            fontSize: 16,
            fontWeight: bold,
          ),
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
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            child: const Text(
              'Back',
            ),
          ),
        ],
      ),
    );
  }
}
