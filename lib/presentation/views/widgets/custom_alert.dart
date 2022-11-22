import 'package:autobaires/core/constants.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert(
      {Key? key,
      required this.title,
      required this.description,
      required this.isShowingError,
      required this.onPressed,
      this.onCancel})
      : super(key: key);

  final String title;
  final String description;
  final bool isShowingError;
  final VoidCallback onPressed;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: COLOR_WHITE,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(isShowingError ? IMAGE_XMARK : IMAGE_CHECK,
                    fit: BoxFit.fill)),
            const SizedBox(height: 30),
            SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                      fontWeight: WEIGHT_TEXT_ONE,
                      fontSize: SIZE_TEXT_ONE,
                      color: COLOR_BLACK_LIGHT),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: Text(
                  description,
                  style: GoogleFonts.roboto(
                      fontWeight: WEIGHT_TEXT_TWO,
                      fontSize: SIZE_TEXT_TWO,
                      color: COLOR_GRAY_DARK),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                )),
            const SizedBox(height: 50),
            Row(
              children: [
                const Spacer(),
                Column(
                  children: [
                    CustomElevatedButton(
                      text: isShowingError ? "Reintentar" : "Continuar",
                      icon: isShowingError
                          ? Icons.sync_rounded
                          : Icons.arrow_circle_right_outlined,
                      isSelected: true,
                      onPressed: onPressed,
                    ),
                    if (isShowingError) ...[
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        text: "Volver",
                        icon: Icons.arrow_back_rounded,
                        isSelected: true,
                        onPressed: onCancel,
                      ),
                    ],
                  ],
                ),
                const Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
