import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMessage extends StatelessWidget {
  const CustomMessage(
      {Key? key, required this.isShowingAlert, required this.description})
      : super(key: key);

  final bool isShowingAlert;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: 70,
        child: AnimatedOpacity(
          opacity: isShowingAlert ? 1 : 0,
          duration: const Duration(milliseconds: 1000),
          child: Container(
              alignment: Alignment.center,
              color: COLOR_BLACK.withOpacity(0.7),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  description,
                  style: GoogleFonts.roboto(
                      fontWeight: WEIGHT_TEXT_ONE,
                      fontSize: SIZE_TEXT_THREE,
                      color: COLOR_WHITE),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ),
      ),
    );
  }
}
