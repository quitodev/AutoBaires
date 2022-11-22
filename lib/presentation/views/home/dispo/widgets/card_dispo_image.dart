import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';

class CardDispoImage extends StatefulWidget {
  const CardDispoImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  State<CardDispoImage> createState() => _CardDispoImageState();
}

class _CardDispoImageState extends State<CardDispoImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        margin: const EdgeInsets.all(10),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RADIUS_CONTAINER),
          child: Image.network(widget.image, fit: BoxFit.fill),
        ));
  }
}
