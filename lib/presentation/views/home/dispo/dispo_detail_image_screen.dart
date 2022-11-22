import 'package:autobaires/core/constants.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DispoDetailImageScreen extends StatefulWidget {
  const DispoDetailImageScreen({Key? key, required this.image})
      : super(key: key);

  final String image;

  static const String routeName = ROUTE_DISPO_DETAIL_IMAGE_SCREEN;

  static Route route({required String image}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => DispoDetailImageScreen(image: image),
    );
  }

  @override
  State<DispoDetailImageScreen> createState() => _DispoDetailImageScreenState();
}

class _DispoDetailImageScreenState extends State<DispoDetailImageScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.data?.getBool(TEXT_SHARED) ?? false) {
            return Scaffold(
              appBar: CustomAppBar(
                title: "Imagen del contrato",
                automaticallyImplyLeading: true,
              ),
              body: PhotoView(
                imageProvider: NetworkImage(widget.image),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: Text(ERROR_TITLE)),
          );
        });
  }
}
