import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/fleet/fleet.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/fleet/fleet_cubit.dart';
import 'package:autobaires/presentation/views/home/fleet/widgets/card_fleet.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_FLEET_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const FleetScreen(),
    );
  }

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.data?.getBool(TEXT_SHARED) ?? false) {
            return BlocProvider(
              create: (_) => sl<FleetCubit>(),
              child: BlocBuilder<FleetCubit, FleetState>(
                builder: (context, state) {
                  return stateManagement(context, state);
                },
              ),
            );
          }
          return const Scaffold(
            body: Center(child: Text(ERROR_TITLE)),
          );
        });
  }

  Widget stateManagement(BuildContext context, FleetState state) {
    if (state is FleetInitial) {
      getFleet(context);
      return const CustomProgress();
    } else if (state is FleetLoading) {
      return const CustomProgress();
    } else if (state is FleetLoaded) {
      final cars = state.list!.where((car) => !car.isDeleted).toList();
      return body(context, cars);
    } else if (state is FleetError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getFleet(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getFleet(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context, List<Fleet> cars) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Flota y Servicios",
          automaticallyImplyLeading: true,
        ),
        floatingActionButton: floatingButtonWidget(context),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget(context, cars),
              const SizedBox(
                height: 20,
              ),
              listWidget(context, cars),
            ],
          ),
        ));
  }

  Widget titleWidget(BuildContext context, List<Fleet> cars) {
    return Text(
      cars.length == 1
          ? "Tenés 1 auto"
          : "Tenés ${cars.where((car) => !car.isDeleted).toList().length} autos",
      style: GoogleFonts.roboto(
          fontWeight: WEIGHT_TEXT_ONE,
          fontSize: SIZE_TEXT_ONE,
          color: COLOR_BLACK),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget listWidget(BuildContext context, List<Fleet> cars) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 175,
        child: RefreshIndicator(
            onRefresh: () => getFleet(context),
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.builder(
                  itemCount:
                      cars.where((car) => !car.isDeleted).toList().length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                                  context, ROUTE_FLEET_DETAIL_SCREEN,
                                  arguments: cars[index])
                              .then((_) => getFleet(context));
                        },
                        child: CardFleet(car: cars[index]));
                  }),
            )));
  }

  Widget floatingButtonWidget(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 12,
      backgroundColor: COLOR_MAGENTA,
      onPressed: () {
        Navigator.pushNamed(context, ROUTE_FLEET_CAR_SCREEN)
            .then((_) => getFleet(context));
      },
      label: Row(
        children: const [
          Icon(
            Icons.add,
            color: COLOR_WHITE,
            size: SIZE_ICON_ONE,
          ),
          SizedBox(
            width: 5,
          ),
          Text(TEXT_ADD),
        ],
      ),
    );
  }

  Future<void> getFleet(BuildContext context) async {
    BlocProvider.of<FleetCubit>(context).getFleet();
  }
}
