import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardContractsInfo extends StatefulWidget {
  const CardContractsInfo({
    Key? key,
    required this.title,
    required this.description,
    required this.background,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String description;
  final Color background;
  final IconData icon;

  @override
  State<CardContractsInfo> createState() => _CardContractsInfoState();
}

class _CardContractsInfoState extends State<CardContractsInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_CARD_DETAIL_INFO,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: COLOR_GRAY_LIGHT,
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            iconWidget(context),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget(context),
                descriptionWidget(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconWidget(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: widget.background,
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon,
        color: COLOR_WHITE,
        size: 20,
      ),
    );
  }

  Widget titleWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 115,
      child: Text(
        widget.title,
        style: GoogleFonts.roboto(
            fontWeight: WEIGHT_TEXT_TWO,
            fontSize: SIZE_TEXT_TWO - 4,
            color: COLOR_GRAY_DARK),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget descriptionWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 115,
      child: Text(
        widget.description,
        style: GoogleFonts.roboto(
            fontWeight: WEIGHT_TEXT_ONE,
            fontSize: SIZE_TEXT_ONE - 6,
            color: COLOR_BLACK_LIGHT),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
