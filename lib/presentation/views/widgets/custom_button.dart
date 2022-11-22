import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      required this.radius,
      required this.textSize,
      required this.height,
      this.width,
      this.iconSize,
      this.icon,
      required this.backgroundColor,
      required this.textColor,
      required this.textWeight})
      : super(key: key);

  final String text;
  final double radius;
  final double textSize;
  final double height;
  final double? width;
  final double? iconSize;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight textWeight;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Row(children: [
        if (widget.icon != null) ...[
          const Spacer(),
          Icon(
            widget.icon,
            color: widget.textColor,
            size: widget.iconSize,
          ),
        ],
        const Spacer(),
        Text(
          widget.text,
          style: GoogleFonts.roboto(
              fontWeight: widget.textWeight,
              fontSize: widget.textSize,
              color: widget.textColor),
          textAlign: TextAlign.left,
        ),
        const Spacer(),
      ]),
    );
  }
}
