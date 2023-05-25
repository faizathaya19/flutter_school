import 'package:bpibs/constants/const.dart';
import 'package:bpibs/ui/Screens/forgetpass_screen.dart';
import 'package:bpibs/ui/Screens/home_screen.dart';
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
            color: Color.fromRGBO(102, 102, 102, 0.8),
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
                  hintText: 'username',
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

Widget passwordTextField(Size size, TextEditingController passwordController) {
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
      onPressed: () {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      },
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
