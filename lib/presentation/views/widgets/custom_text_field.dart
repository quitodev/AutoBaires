import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    this.hint,
    required this.icon,
    this.inputType,
    this.obscureText,
    this.onChanged,
  }) : super(key: key);

  final String title;
  final String? hint;
  final IconData icon;
  final TextInputType? inputType;
  final bool? obscureText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                  fontWeight: WEIGHT_TEXT_ONE,
                  fontSize: SIZE_TEXT_TWO,
                  color: COLOR_BLACK_LIGHT),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                keyboardType: inputType,
                obscureText: obscureText ?? false,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hint ?? "",
                  prefixIcon: Icon(icon, color: COLOR_MAGENTA),
                  contentPadding: const EdgeInsets.only(left: 5, top: 10),
                  focusColor: COLOR_VIOLET,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: COLOR_VIOLET),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
