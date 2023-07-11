import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/const.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  final Size size;
  final Function()? onTap;
  final bool readOnly;
  final int? maxLines;

  const BuildTextField({
    Key? key,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
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
      margin: const EdgeInsets.symmetric(vertical: 10),
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
          const SizedBox(height: 5),
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
                keyboardType: keyboardType,
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
