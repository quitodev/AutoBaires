import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/contracts/contracts.dart';
import 'package:autobaires/presentation/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardContracts extends StatefulWidget {
  const CardContracts({
    Key? key,
    required this.contract,
  }) : super(key: key);

  final Contracts contract;

  @override
  State<CardContracts> createState() => _CardContractsState();
}

class _CardContractsState extends State<CardContracts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_CARD_CONTRACTS,
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
                  customerWidget(context),
                  driverWidget(context),
                  commentsWidget(context),
                  SizedBox(
                    height: 25,
                    child: Row(
                      children: [
                        startDateWidget(context),
                        const SizedBox(
                          width: 5,
                        ),
                        endDateWidget(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                daysWidget(context),
                const Spacer(),
                imageWidget(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget modelWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "#${widget.contract.id}",
            style: GoogleFonts.roboto(
                fontWeight: WEIGHT_TEXT_ONE,
                fontSize: SIZE_TEXT_THREE,
                color: COLOR_MAGENTA),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        if (widget.contract.isReplaced) ...[
          const Icon(
            Icons.sync_rounded,
            color: COLOR_VIOLET,
            size: SIZE_ICON_ONE - 1,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
        SizedBox(
          width: MediaQuery.of(context).size.width > 600
              ? WIDTH_CARD_WEB - 45
              : WIDTH_CARD - 45,
          child: Text(
            widget.contract.isReplaced
                ? widget.contract.modelNew.toUpperCase()
                : widget.contract.model.toUpperCase(),
            style: GoogleFonts.roboto(
                fontWeight: WEIGHT_TEXT_ONE,
                fontSize: SIZE_TEXT_THREE,
                color: COLOR_BLACK_LIGHT),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget plateWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width > 600
                ? WIDTH_CARD_WEB
                : WIDTH_CARD,
            child: Text(
              widget.contract.isReplaced
                  ? widget.contract.plateNew.toUpperCase()
                  : widget.contract.plate.toUpperCase(),
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
      ),
    );
  }

  Widget customerWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(
            Icons.people_rounded,
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
              widget.contract.customer,
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

  Widget driverWidget(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
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
              widget.contract.driver,
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
              widget.contract.comments == EMPTY
                  ? NO_COMMENTS
                  : widget.contract.comments,
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

  Widget startDateWidget(BuildContext context) {
    return CustomButton(
      text: widget.contract.startDate.substring(0, 8),
      radius: RADIUS_BUTTON,
      textSize: SIZE_TEXT_THREE - 2,
      height: 25,
      backgroundColor: COLOR_GRAY_DARK,
      textColor: COLOR_WHITE,
      textWeight: WEIGHT_TEXT_THREE,
      width: 90,
      icon: Icons.calendar_month_rounded,
      iconSize: SIZE_ICON_TWO,
    );
  }

  Widget endDateWidget(BuildContext context) {
    return CustomButton(
      text: widget.contract.endDate.substring(0, 8),
      radius: RADIUS_BUTTON,
      textSize: SIZE_TEXT_THREE - 2,
      height: 25,
      backgroundColor: COLOR_GRAY_DARK,
      textColor: COLOR_WHITE,
      textWeight: WEIGHT_TEXT_THREE,
      width: 90,
      icon: Icons.calendar_month_rounded,
      iconSize: SIZE_ICON_TWO,
    );
  }

  Widget daysWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (getDays() > 1) ...[
          CustomButton(
            text: "${getDays()} días",
            radius: RADIUS_BUTTON,
            textSize: SIZE_TEXT_THREE - 2,
            height: 25,
            backgroundColor: COLOR_VIOLET,
            textColor: COLOR_WHITE,
            textWeight: WEIGHT_TEXT_THREE,
            width: 75,
            icon: Icons.timer_outlined,
            iconSize: SIZE_ICON_TWO,
          ),
        ],
        if (getDays() <= 1) ...[
          CustomButton(
            text: getDays() == 1
                ? "Mañana"
                : getDays() == 0
                    ? "Hoy"
                    : "Finalizó",
            radius: RADIUS_BUTTON,
            textSize: SIZE_TEXT_THREE - 2,
            height: 25,
            backgroundColor: getDays() == 1
                ? COLOR_ORANGE
                : getDays() == 0
                    ? COLOR_RED
                    : COLOR_GRAY_DARK,
            textColor: COLOR_WHITE,
            textWeight: WEIGHT_TEXT_THREE,
            width: getDays() == 0 ? 60 : 75,
            icon: Icons.timer_outlined,
            iconSize: SIZE_ICON_TWO,
          ),
        ],
      ],
    );
  }

  Widget imageWidget(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RADIUS_IMAGE),
        child: Image.asset(widget.contract.image, fit: BoxFit.cover),
      ),
    );
  }

  int getDays() {
    String currentDate = DateFormat("dd/MM/yy").format(DateTime.now());
    String currentHour = DateFormat("Hm").format(DateTime.now());
    String fromEdited =
        "20${currentDate.substring(6, 8)}-${currentDate.substring(3, 5)}-${currentDate.substring(0, 2)} $currentHour:00.000000";
    String toEdited =
        "20${widget.contract.endDate.substring(6, 8)}-${widget.contract.endDate.substring(3, 5)}-${widget.contract.endDate.substring(0, 2)} 00:00:00.000000";
    DateTime from = DateTime.parse(fromEdited);
    DateTime to = DateTime.parse(toEdited);

    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }
}
