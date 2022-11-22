import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';

class CustomProgress extends StatelessWidget {
  const CustomProgress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: COLOR_WHITE,
        child: const CircularProgressIndicator(
          color: COLOR_VIOLET,
        ));
  }
}
