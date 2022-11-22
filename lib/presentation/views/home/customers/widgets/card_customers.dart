import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardCustomers extends StatefulWidget {
  const CardCustomers({
    Key? key,
    required this.customer,
  }) : super(key: key);

  final Customers customer;

  @override
  State<CardCustomers> createState() => _CardCustomersState();
}

class _CardCustomersState extends State<CardCustomers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_CARD_CUSTOMERS,
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
                  customerWidget(context),
                  driversWidget(context),
                  commentsWidget(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customerWidget(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width > 600 ? WIDTH_CARD_WEB : WIDTH_CARD,
      child: Text(
        widget.customer.customer.toUpperCase(),
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

  Widget driversWidget(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.sports_motorsports_rounded,
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
            widget.customer.drivers.length == 1
                ? "1 conductor"
                : "${widget.customer.drivers.length} conductores",
            style: GoogleFonts.roboto(
                fontWeight: WEIGHT_TEXT_THREE,
                fontSize: SIZE_TEXT_THREE,
                color: COLOR_BLACK_LIGHT),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
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
              widget.customer.comments == EMPTY
                  ? NO_COMMENTS
                  : widget.customer.comments,
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
}
