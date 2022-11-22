import 'package:autobaires/core/constants.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/home/widgets/card_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_HOME_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.data?.getBool(TEXT_SHARED) ?? false) {
            return body();
          }
          return const Scaffold(
            body: Center(child: Text(ERROR_TITLE)),
          );
        });
  }

  Widget body() {
    return Scaffold(
      appBar: CustomAppBar(
        title: "¡Bienvenid@ a Auto Baires!",
        automaticallyImplyLeading: false,
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ROUTE_DISPO_SCREEN);
                  },
                  child: const CardHome(
                    image: IMAGE_DISPO,
                    title: "Disponibilidad",
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ROUTE_CONTRACTS_SCREEN);
                  },
                  child: const CardHome(
                      image: IMAGE_CONTRACTS, title: "Contratos")),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ROUTE_FLEET_SCREEN);
                  },
                  child: const CardHome(
                      image: IMAGE_FLEET, title: "Flota y Servicios")),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, ROUTE_CUSTOMERS_SCREEN);
                  },
                  child: const CardHome(
                      image: IMAGE_CUSTOMERS, title: "Clientes y Conductores")),
            ],
          )),
    );
  }
}
