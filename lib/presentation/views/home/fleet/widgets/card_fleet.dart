import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/fleet/fleet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardFleet extends StatefulWidget {
  const CardFleet({
    Key? key,
    required this.car,
  }) : super(key: key);

  final Fleet car;

  @override
  State<CardFleet> createState() => _CardFleetState();
}

class _CardFleetState extends State<CardFleet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_CARD_FLEET,
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 5),
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
            SizedBox(
              width: MediaQuery.of(context).size.width > 600
                  ? WIDTH_CARD_WEB
                  : WIDTH_CARD,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  modelWidget(context),
                  plateWidget(context),
                  kilometresWidget(context),
                  commentsWidget(context),
                  ubicationWidget(context),
                ],
              ),
            ),
            const Spacer(),
            imageWidget(context),
          ],
        ),
      ),
    );
  }

  Widget modelWidget(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width > 600 ? WIDTH_CARD_WEB : WIDTH_CARD,
      child: Text(
        widget.car.model.toUpperCase(),
        style: GoogleFonts.roboto(
            fontWeight: WEIGHT_TEXT_ONE,
            fontSize: SIZE_TEXT_THREE,
            color: COLOR_BLACK_LIGHT),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget plateWidget(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width > 600
              ? WIDTH_CARD_WEB
              : WIDTH_CARD,
          child: Text(
            widget.car.plate.toUpperCase(),
            style: GoogleFonts.roboto(
                fontWeight: WEIGHT_TEXT_ONE,
                fontSize: SIZE_TEXT_THREE,
                color: COLOR_VIOLET),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget kilometresWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(
            Icons.speed_rounded,
            color: COLOR_ORANGE,
            size: SIZE_ICON_ONE,
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width > 600
                ? WIDTH_TEXT_CARD_BIG_WEB
                : WIDTH_TEXT_CARD_BIG,
            child: Text(
              "${widget.car.kilometres} Km.",
              style: GoogleFonts.roboto(
                  fontWeight: WEIGHT_TEXT_THREE,
                  fontSize: SIZE_TEXT_THREE,
                  color: COLOR_BLACK_LIGHT),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget commentsWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(
            Icons.comment_rounded,
            color: COLOR_AQUA,
            size: SIZE_ICON_ONE,
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width > 600
                ? WIDTH_TEXT_CARD_BIG_WEB
                : WIDTH_TEXT_CARD_BIG,
            child: Text(
              widget.car.comments == EMPTY ? NO_COMMENTS : widget.car.comments,
              style: GoogleFonts.roboto(
                  fontWeight: WEIGHT_TEXT_THREE,
                  fontSize: SIZE_TEXT_THREE,
                  color: COLOR_BLACK_LIGHT),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget ubicationWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(
            Icons.pin_drop_rounded,
            color: COLOR_RED,
            size: SIZE_ICON_ONE,
          ),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width > 600
                ? WIDTH_TEXT_CARD_BIG_WEB
                : WIDTH_TEXT_CARD_BIG,
            child: Text(
              widget.car.ubication,
              style: GoogleFonts.roboto(
                  fontWeight: WEIGHT_TEXT_THREE,
                  fontSize: SIZE_TEXT_THREE,
                  color: COLOR_BLACK_LIGHT),
              textAlign: TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Spacer(),
        SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RADIUS_IMAGE),
            child: Image.asset(widget.car.image, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
