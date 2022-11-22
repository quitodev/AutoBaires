import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.icon,
    required this.isSelected,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final IconData? icon;
  final bool isSelected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2, top: 2),
      child: Row(
        children: [
          if (icon == null) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: COLOR_WHITE,
                  backgroundColor:
                      isSelected ? COLOR_MAGENTA : COLOR_BLACK_LIGHT,
                  shadowColor: COLOR_SHADOW,
                  elevation: ELEVATION_BUTTON,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RADIUS_BUTTON),
                  )),
              onPressed: onPressed,
              child: Text(
                text,
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_THREE,
                    fontSize: SIZE_TEXT_THREE,
                    color: onPressed == null ? COLOR_BLACK_LIGHT : COLOR_WHITE),
                textAlign: TextAlign.left,
              ),
            ),
          ],
          if (icon != null) ...[
            ElevatedButton.icon(
              icon: Icon(icon, size: SIZE_ICON_ONE),
              style: ElevatedButton.styleFrom(
                  foregroundColor: COLOR_WHITE,
                  backgroundColor:
                      isSelected ? COLOR_MAGENTA : COLOR_BLACK_LIGHT,
                  shadowColor: COLOR_SHADOW,
                  elevation: ELEVATION_BUTTON,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(RADIUS_BUTTON),
                  )),
              onPressed: onPressed,
              label: Text(
                text,
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_THREE,
                    fontSize: SIZE_TEXT_THREE,
                    color: onPressed == null ? COLOR_BLACK_LIGHT : COLOR_WHITE),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
