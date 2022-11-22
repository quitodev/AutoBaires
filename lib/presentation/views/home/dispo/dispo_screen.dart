import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/dispo/dispo.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/dispo/dispo_cubit.dart';
import 'package:autobaires/presentation/views/home/dispo/widgets/card_dispo.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DispoScreen extends StatefulWidget {
  const DispoScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_DISPO_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: ROUTE_DISPO_SCREEN),
      builder: (_) => const DispoScreen(),
    );
  }

  @override
  State<DispoScreen> createState() => _DispoScreenState();
}

class _DispoScreenState extends State<DispoScreen> {
  final ScrollController controller = ScrollController();
  bool isReleaseSelected = false;
  List<Dispo> carsFiltered = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.data?.getBool(TEXT_SHARED) ?? false) {
            return BlocProvider(
              create: (_) => sl<DispoCubit>(),
              child: BlocBuilder<DispoCubit, DispoState>(
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

  Widget stateManagement(BuildContext context, DispoState state) {
    if (state is DispoInitial) {
      getDispo(context);
      return const CustomProgress();
    } else if (state is DispoLoading) {
      return const CustomProgress();
    } else if (state is DispoLoaded) {
      final cars = state.list!;
      carsFiltered =
          cars.where((car) => car.isReleased == isReleaseSelected).toList();
      return body(context, cars);
    } else if (state is DispoError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getDispo(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getDispo(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context, List<Dispo> cars) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Disponibilidad",
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buttonsWidget(context, cars),
              const SizedBox(
                height: 20,
              ),
              titleWidget(context),
              const SizedBox(
                height: 20,
              ),
              listWidget(context),
            ],
          ),
        ));
  }

  Widget buttonsWidget(BuildContext context, List<Dispo> cars) {
    return Container(
        height: 35,
        alignment: Alignment.centerLeft,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CustomElevatedButton(
              text: "En uso",
              icon: Icons.directions_car_rounded,
              isSelected: !isReleaseSelected,
              onPressed: (() {
                setState(() {
                  isReleaseSelected = false;
                  carsFiltered = cars
                      .where((car) => car.isReleased == isReleaseSelected)
                      .toList();
                });
              }),
            ),
            const SizedBox(width: 15),
            CustomElevatedButton(
              text: "Libres",
              icon: Icons.key_rounded,
              isSelected: isReleaseSelected,
              onPressed: (() {
                setState(() {
                  isReleaseSelected = true;
                  carsFiltered = cars
                      .where((car) => car.isReleased == isReleaseSelected)
                      .toList();
                  carsFiltered.sort((a, b) => a.model.compareTo(b.model));
                });
              }),
            )
          ],
        ));
  }

  Widget titleWidget(BuildContext context) {
    return Text(
      isReleaseSelected
          ? "Tenés ${carsFiltered.length == 1 ? '1 auto libre' : '${carsFiltered.length} autos libres'}"
          : "Tenés ${carsFiltered.length == 1 ? '1 auto en uso' : '${carsFiltered.length} autos en uso'}",
      style: GoogleFonts.roboto(
          fontWeight: WEIGHT_TEXT_ONE,
          fontSize: SIZE_TEXT_ONE,
          color: COLOR_BLACK),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget listWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 230,
        child: RefreshIndicator(
            onRefresh: () => getDispo(context),
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.builder(
                  controller: controller,
                  itemCount: carsFiltered.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                                  context, ROUTE_DISPO_DETAIL_SCREEN,
                                  arguments: carsFiltered[index])
                              .then((_) => getDispo(context));
                        },
                        child: CardDispo(car: carsFiltered[index]));
                  }),
            )));
  }

  Future<void> getDispo(BuildContext context) async {
    BlocProvider.of<DispoCubit>(context).getDispo();
  }
}
