import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/dispo/dispo.dart';
import 'package:autobaires/presentation/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CardDispoServices extends StatefulWidget {
  const CardDispoServices({
    Key? key,
    required this.service,
    required this.carKilometres,
    required this.background,
    required this.icon,
  }) : super(key: key);

  final DispoFleetServices service;
  final int carKilometres;
  final Color background;
  final IconData icon;

  @override
  State<CardDispoServices> createState() => _CardDispoServicesState();
}

class _CardDispoServicesState extends State<CardDispoServices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_CARD_DETAIL_SERVICES,
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
                jobWidget(context),
                providerWidget(context),
                dateWidget(context),
                commentsWidget(context),
              ],
            ),
            const Spacer(),
            kilometresWidget(context),
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

  Widget jobWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? WIDTH_TEXT_CARD_SMALL_WEB
          : WIDTH_TEXT_CARD_SMALL,
      child: Text(
        widget.service.job,
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

  Widget providerWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? WIDTH_TEXT_CARD_SMALL_WEB
          : WIDTH_TEXT_CARD_SMALL,
      child: Text(
        widget.service.provider,
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

  Widget dateWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? WIDTH_TEXT_CARD_SMALL_WEB
          : WIDTH_TEXT_CARD_SMALL,
      child: Text(
        widget.service.date,
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

  Widget commentsWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? WIDTH_TEXT_CARD_SMALL_WEB
          : WIDTH_TEXT_CARD_SMALL,
      child: Text(
        widget.service.comments == EMPTY
            ? NO_COMMENTS
            : widget.service.comments,
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

  Widget kilometresWidget(BuildContext context) {
    return Column(
      children: [
        if (widget.service.job != TEXT_SERVICE_BATERIA &&
            widget.service.job != TEXT_SERVICE_CEDULA &&
            widget.service.job != TEXT_SERVICE_KILOMETRAJE &&
            widget.service.job != TEXT_SERVICE_VTV) ...[
          CustomButton(
            text: getKilometres() > 0
                ? "${NumberFormat("#,##0").format(getKilometres())} Km."
                : "¡Arreglar!",
            radius: RADIUS_BUTTON,
            textSize: SIZE_TEXT_THREE - 2,
            height: 25,
            backgroundColor: getKilometres() > 0 ? COLOR_VIOLET : COLOR_RED,
            textColor: COLOR_WHITE,
            textWeight: WEIGHT_TEXT_THREE,
            width: getKilometres() > 0 ? 100 : 80,
            icon: Icons.build_rounded,
            iconSize: SIZE_ICON_TWO,
          ),
        ],
        if (widget.service.job == TEXT_SERVICE_CEDULA ||
            widget.service.job == TEXT_SERVICE_VTV) ...[
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
                      : "¡Renovar!",
              radius: RADIUS_BUTTON,
              textSize: SIZE_TEXT_THREE - 2,
              height: 25,
              backgroundColor: getDays() == 1 ? COLOR_ORANGE : COLOR_RED,
              textColor: COLOR_WHITE,
              textWeight: WEIGHT_TEXT_THREE,
              width: getDays() == 0 ? 60 : 75,
              icon: Icons.timer_outlined,
              iconSize: SIZE_ICON_TWO,
            ),
          ],
        ],
        const Spacer(),
      ],
    );
  }

  int getKilometres() {
    int kilometresToShow = 0;
    if (widget.service.job == TEXT_SERVICE_ACEITE) {
      kilometresToShow = getKilometresByJob(10000);
    }
    if (widget.service.job == TEXT_SERVICE_CUBIERTAS) {
      kilometresToShow = getKilometresByJob(30000);
    }
    if (widget.service.job == TEXT_SERVICE_CORREA) {
      kilometresToShow = getKilometresByJob(40000);
    }
    if (widget.service.job == TEXT_SERVICE_FRENO_DEL) {
      kilometresToShow = getKilometresByJob(20000);
    }
    if (widget.service.job == TEXT_SERVICE_FRENO_TRA) {
      kilometresToShow = getKilometresByJob(40000);
    }
    if (widget.service.job == TEXT_SERVICE_DISCOS_DEL) {
      kilometresToShow = getKilometresByJob(80000);
    }
    if (widget.service.job == TEXT_SERVICE_DISCOS_TRA) {
      kilometresToShow = getKilometresByJob(80000);
    }
    return kilometresToShow;
  }

  int getKilometresByJob(int change) {
    int kilometresToShow = 0;
    if (widget.carKilometres <= widget.service.kilometres) {
      kilometresToShow = change;
    } else {
      if (change >= widget.carKilometres) {
        if (change < widget.service.kilometres) {
          kilometresToShow = change;
        } else {
          if (widget.service.kilometres > 0) {
            kilometresToShow =
                change + widget.service.kilometres - widget.carKilometres;
          }
        }
      } else {
        if (change + widget.service.kilometres - widget.carKilometres > 0) {
          kilometresToShow =
              change + widget.service.kilometres - widget.carKilometres;
        }
      }
    }
    return kilometresToShow;
  }

  int getDays() {
    String currentDate = DateFormat("dd/MM/yy").format(DateTime.now());
    String currentHour = DateFormat("Hm").format(DateTime.now());
    String fromEdited =
        "20${currentDate.substring(6, 8)}-${currentDate.substring(3, 5)}-${currentDate.substring(0, 2)} $currentHour:00.000000";
    String toEdited =
        "20${int.parse(widget.service.date.substring(6, 8)) + 1}-${widget.service.date.substring(3, 5)}-${widget.service.date.substring(0, 2)} 00:00:00.000000";
    DateTime from = DateTime.parse(fromEdited);
    DateTime to = DateTime.parse(toEdited);

    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }
}
