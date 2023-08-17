import 'package:bpibs/constants/const.dart';
import 'package:flutter/material.dart';

class BuildDropdownButton extends StatelessWidget {
  final String? value;
  final Function(String?) onChanged;
  final List<DropdownMenuItem<String>> items;
  final String hintText;
  final String labelText;
  final Size size;

  const BuildDropdownButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.hintText,
    required this.labelText,
    required this.size,
  });

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
              child: DropdownButton<String>(
                value: value,
                onChanged: onChanged,
                underline: const SizedBox(),
                isExpanded: true,
                items: items,
                hint: Text(hintText),
              ),
            ),
          )
        ],
      ),
    );
  }
}
