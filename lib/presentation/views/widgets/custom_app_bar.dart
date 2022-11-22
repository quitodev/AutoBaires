import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  CustomAppBar(
      {Key? key,
      this.title,
      required this.automaticallyImplyLeading,
      this.isSearching,
      this.onPressed})
      : super(key: key);

  final String? title;
  final bool automaticallyImplyLeading;
  final bool? isSearching;
  final Function()? onPressed;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: Container(
        alignment: Alignment.centerLeft,
        padding: widget.automaticallyImplyLeading
            ? const EdgeInsets.symmetric(vertical: 10, horizontal: 0)
            : const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(
          widget.title ?? "",
          style: GoogleFonts.roboto(
              fontWeight: WEIGHT_TEXT_ONE,
              fontSize: SIZE_TEXT_ONE,
              color: COLOR_BLACK),
          textAlign: TextAlign.left,
        ),
      ),
      iconTheme: const IconThemeData(color: COLOR_BLACK),
      actions: [
        if (widget.onPressed != null) ...[
          IconButton(
            icon: Icon(
              widget.isSearching != null
                  ? Icons.search_rounded
                  : Icons.delete_forever_rounded,
              color: widget.isSearching != null ? COLOR_VIOLET : COLOR_RED,
            ),
            onPressed: widget.onPressed,
          ),
        ],
        if (widget.automaticallyImplyLeading) ...[
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, ROUTE_HOME_SCREEN, (route) => false);
            },
          ),
        ],
      ],
    );
  }
}
