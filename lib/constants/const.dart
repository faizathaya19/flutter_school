import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color backgroundColor1 = const Color.fromARGB(255, 110, 204, 175);
Color backgroundCard1 = const Color.fromARGB(255, 219, 219, 219);
Color buttonColor1 = const Color.fromARGB(255, 31, 29, 43);
Color inputColor1 = const Color.fromRGBO(246, 249, 255, 0.6);
Color primaryTextColor = const Color(0xffF1F0F2);
Color basicTextColor = Color.fromARGB(255, 0, 0, 0);
Color secondaryTextColor = const Color(0xff999999);
Color inputColor4 = const Color.fromRGBO(102, 102, 102, 0.8);

TextStyle primaryTextStyle = GoogleFonts.poppins(
  color: primaryTextColor,
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: secondaryTextColor,
);

TextStyle basicTextStyle = GoogleFonts.poppins(
  color: basicTextColor,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

Widget topbg() {
  return Positioned.fill(
    right: -150,
    child: Opacity(
      opacity: 0.3,
      child: Align(
        alignment: Alignment.topRight,
        child: Image.asset(
          'assets/Logo.png',
          width: 478,
        ),
      ),
    ),
  );
}

Widget bottombg() {
  return Positioned.fill(
    left: -150,
    child: Opacity(
      opacity: 0.3,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Image.asset(
          'assets/Logo.png',
          width: 731,
        ),
      ),
    ),
  );
}
