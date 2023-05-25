import 'package:bpibs/constants/const.dart';
import 'package:bpibs/ui/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

Widget usernameTextField(Size size, TextEditingController usernameController) {
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
