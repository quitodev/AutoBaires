import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/fleet/fleet.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/fleet/fleet_cubit.dart';
import 'package:autobaires/presentation/views/home/fleet/widgets/card_fleet_info.dart';
import 'package:autobaires/presentation/views/home/fleet/widgets/card_fleet_services.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FleetDetailScreen extends StatefulWidget {
  const FleetDetailScreen({Key? key, required this.car}) : super(key: key);

  final Fleet car;

  static const String routeName = ROUTE_FLEET_DETAIL_SCREEN;

  static Route route({required Fleet car}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => FleetDetailScreen(car: car),
    );
  }

  @override
  State<FleetDetailScreen> createState() => _FleetDetailScreenState();
}

class _FleetDetailScreenState extends State<FleetDetailScreen> {
  bool isInfoSelected = true;
  bool isServicesSelected = false;
  List<FleetServices> services = [];

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
      return body(context);
    } else if (state is FleetLoading) {
      return const CustomProgress();
    } else if (state is FleetLoaded) {
      return CustomAlert(
          title: "Auto eliminado con éxito",
          description:
              "¡El auto ${widget.car.model.toUpperCase()} (${widget.car.plate.toUpperCase()}) se eliminó exitosamente!",
          isShowingError: false,
          onPressed: () => Navigator.of(context).pop());
    } else if (state is FleetError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => deleteFleet(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => deleteFleet(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Info del auto",
        automaticallyImplyLeading: true,
        onPressed: () {
          setState(() {
            showAlertDialog(
                context,
                "¿Confirmás la eliminación del ${widget.car.model.toUpperCase()} (${widget.car.plate.toUpperCase()})?",
                "Si confirmás la acción no se puede volver atrás (los contratos que tengan el auto asignado seguirán estando)...",
                "ELIMINAR");
          });
        },
      ),
      //extendBodyBehindAppBar: true,
      floatingActionButton: floatingButtonWidget(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget(context),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  modelWidget(context),
                  const SizedBox(
                    height: 5,
                  ),
                  plateWidget(context),
                  const SizedBox(
                    height: 5,
                  ),
                  kilometresWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  buttonsWidget(context),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isInfoSelected) ...[
                    infoWidget(context),
                  ],
                  if (isServicesSelected) ...[
                    listWidget(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(BuildContext context) {
    return SizedBox(
        height: 160,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.asset(IMAGE_DISPO,
                width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.white,
                  Colors.transparent,
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
            ),
          ],
        ));
  }

  Widget modelWidget(BuildContext context) {
    return Text(
      widget.car.model.toUpperCase(),
      style: GoogleFonts.roboto(
          fontWeight: WEIGHT_TEXT_ONE,
          fontSize: SIZE_TEXT_ONE - 2,
          color: COLOR_BLACK),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget plateWidget(BuildContext context) {
    return Text(
      widget.car.plate.toUpperCase(),
      style: GoogleFonts.roboto(
          fontWeight: WEIGHT_TEXT_ONE,
          fontSize: SIZE_TEXT_ONE - 2,
          color: COLOR_VIOLET),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget kilometresWidget(BuildContext context) {
    return Text(
      "${NumberFormat("#,##0").format(widget.car.kilometres)} Km.",
      style: GoogleFonts.roboto(
          fontWeight: WEIGHT_TEXT_ONE,
          fontSize: SIZE_TEXT_TWO,
          color: COLOR_ORANGE),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buttonsWidget(BuildContext context) {
    return Container(
        height: 35,
        alignment: Alignment.centerLeft,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CustomElevatedButton(
              text: "Info",
              icon: Icons.assignment_rounded,
              isSelected: isInfoSelected,
              onPressed: (() {
                setState(() {
                  isInfoSelected = true;
                  isServicesSelected = false;
                });
              }),
            ),
            const SizedBox(width: 15),
            CustomElevatedButton(
              text: "Servicios",
              icon: Icons.build_rounded,
              isSelected: isServicesSelected,
              onPressed: (() {
                setState(() {
                  isInfoSelected = false;
                  isServicesSelected = true;
                });
              }),
            ),
          ],
        ));
  }

  Widget infoWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 420,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView(
            children: [
              CardFleetInfo(
                  title: "Deudas de patentes",
                  description: widget.car.debtsPlate,
                  background: COLOR_BLUE,
                  icon: Icons.monetization_on_outlined),
              CardFleetInfo(
                  title: "Deudas de infracciones",
                  description: widget.car.debtsInfractions,
                  background: COLOR_ORANGE,
                  icon: Icons.monetization_on_outlined),
              CardFleetInfo(
                  title: "Ubicación",
                  description: widget.car.ubication,
                  background: COLOR_RED,
                  icon: Icons.pin_drop_rounded),
              CardFleetInfo(
                  title: "Comentarios",
                  description: widget.car.comments == EMPTY
                      ? NO_COMMENTS
                      : widget.car.comments,
                  background: COLOR_AQUA,
                  icon: Icons.comment_rounded),
            ],
          ),
        ));
  }

  Widget listWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 420,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView.builder(
              itemCount: widget.car.services.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ROUTE_FLEET_SERVICES_SCREEN,
                          arguments: FleetArguments(
                              car: widget.car,
                              service: widget.car.services[index]));
                    },
                    child: CardFleetServices(
                        service: widget.car.services[index],
                        carKilometres: widget.car.kilometres,
                        background: COLOR_RED,
                        icon: Icons.tire_repair_rounded));
              }),
        ));
  }

  Widget floatingButtonWidget(BuildContext context) {
    return Visibility(
      visible: isInfoSelected,
      child: FloatingActionButton.extended(
        elevation: 12,
        backgroundColor: COLOR_MAGENTA,
        onPressed: () {
          Navigator.pushNamed(context, ROUTE_FLEET_CAR_SCREEN,
              arguments: widget.car);
        },
        label: Row(
          children: const [
            Icon(
              Icons.edit_rounded,
              color: COLOR_WHITE,
              size: SIZE_ICON_ONE,
            ),
            SizedBox(
              width: 5,
            ),
            Text(TEXT_MODIFY),
          ],
        ),
      ),
    );
  }

  showAlertDialog(
      BuildContext context, String title, String content, String confirm) {
    Widget cancelButton = TextButton(
      child: const Text(TEXT_CANCEL),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(confirm),
      onPressed: () {
        setState(() {
          deleteFleet(context);
        });
        Navigator.of(context).pop();
      },
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
  }

  Future<void> deleteFleet(BuildContext context) async {
    BlocProvider.of<FleetCubit>(context).deleteFleet(id: widget.car.id);
  }
}
