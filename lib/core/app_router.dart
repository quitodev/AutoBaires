import 'package:autobaires/domain/entities/contracts/contracts.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/domain/entities/dispo/dispo.dart';
import 'package:autobaires/domain/entities/fleet/fleet.dart';
import 'package:autobaires/presentation/views/home/contracts/contracts_detail_image_screen.dart';
import 'package:autobaires/presentation/views/home/contracts/contracts_detail_screen.dart';
import 'package:autobaires/presentation/views/home/contracts/contracts_new_screen.dart';
import 'package:autobaires/presentation/views/home/contracts/contracts_screen.dart';
import 'package:autobaires/presentation/views/home/contracts/contracts_search_screen.dart';
import 'package:autobaires/presentation/views/home/customers/customers_detail_screen.dart';
import 'package:autobaires/presentation/views/home/customers/customers_new_screen.dart';
import 'package:autobaires/presentation/views/home/customers/customers_screen.dart';
import 'package:autobaires/presentation/views/home/dispo/dispo_detail_image_screen.dart';
import 'package:autobaires/presentation/views/home/dispo/dispo_detail_screen.dart';
import 'package:autobaires/presentation/views/home/dispo/dispo_screen.dart';
import 'package:autobaires/presentation/views/home/fleet/fleet_car_screen.dart';
import 'package:autobaires/presentation/views/home/fleet/fleet_detail_screen.dart';
import 'package:autobaires/presentation/views/home/fleet/fleet_screen.dart';
import 'package:autobaires/presentation/views/home/fleet/fleet_services_screen.dart';
import 'package:autobaires/presentation/views/home/home_screen.dart';
import 'package:autobaires/presentation/views/login/login_screen.dart';
import 'package:autobaires/presentation/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return HomeScreen.route();

      case SplashScreen.routeName:
        return SplashScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case DispoScreen.routeName:
        return DispoScreen.route();
      case DispoDetailScreen.routeName:
        return DispoDetailScreen.route(car: settings.arguments as Dispo);
      case DispoDetailImageScreen.routeName:
        return DispoDetailImageScreen.route(
            image: settings.arguments as String);

      case ContractsScreen.routeName:
        return ContractsScreen.route();
      case ContractsDetailScreen.routeName:
        return ContractsDetailScreen.route(
            contract: settings.arguments as Contracts);
      case ContractsDetailImageScreen.routeName:
        return ContractsDetailImageScreen.route(
            image: settings.arguments as String);
      case ContractsNewScreen.routeName:
        return ContractsNewScreen.route(
            contract: settings.arguments as Contracts);
      case ContractsSearchScreen.routeName:
        return ContractsSearchScreen.route(
            contracts: settings.arguments as List<Contracts>);

      case FleetScreen.routeName:
        return FleetScreen.route();
      case FleetDetailScreen.routeName:
        return FleetDetailScreen.route(car: settings.arguments as Fleet);
      case FleetCarScreen.routeName:
        return FleetCarScreen.route(car: settings.arguments as Fleet?);
      case FleetServicesScreen.routeName:
        return FleetServicesScreen.route(
            args: settings.arguments as FleetArguments);

      case CustomersScreen.routeName:
        return CustomersScreen.route();
      case CustomersDetailScreen.routeName:
        return CustomersDetailScreen.route(
            customer: settings.arguments as Customers);
      case CustomersNewScreen.routeName:
        return CustomersNewScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "/error"),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: const Center(
          child: Text("Something went wrong!"),
        ),
      ),
    );
  }
}
