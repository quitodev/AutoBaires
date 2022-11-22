import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardHome extends StatefulWidget {
  const CardHome({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: HEIGHT_CARD_HOME,
        margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5, top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RADIUS_CONTAINER),
          boxShadow: const [
            BoxShadow(
              color: COLOR_SHADOW,
              spreadRadius: SHADOW_SPREAD_RADIUS,
              blurRadius: SHADOW_BLUR_RADIUS,
              offset: Offset(SHADOW_OFFSET_X, SHADOW_OFFSET_Y),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(RADIUS_CONTAINER),
              child: Image.asset(widget.image,
                  width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 60, 60, 60),
                  Color.fromARGB(0, 60, 60, 60),
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                borderRadius: BorderRadius.circular(RADIUS_CONTAINER),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: GoogleFonts.roboto(
                            fontWeight: WEIGHT_TEXT_ONE,
                            fontSize: SIZE_TEXT_ONE,
                            color: COLOR_WHITE),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
