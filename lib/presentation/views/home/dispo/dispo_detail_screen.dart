import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/dispo/dispo.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/dispo/dispo_cubit.dart';
import 'package:autobaires/presentation/views/home/dispo/widgets/card_dispo_image.dart';
import 'package:autobaires/presentation/views/home/dispo/widgets/card_dispo_info.dart';
import 'package:autobaires/presentation/views/home/dispo/widgets/card_dispo_services.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_message.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DispoDetailScreen extends StatefulWidget {
  const DispoDetailScreen({Key? key, required this.car}) : super(key: key);

  final Dispo car;

  static const String routeName = ROUTE_DISPO_DETAIL_SCREEN;

  static Route route({required Dispo car}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => DispoDetailScreen(car: car),
    );
  }

  @override
  State<DispoDetailScreen> createState() => _DispoDetailScreenState();
}

class _DispoDetailScreenState extends State<DispoDetailScreen> {
  bool isShowingAlert = false;
  bool isInfoSelected = true;
  bool isDocumentsSelected = false;
  bool isServicesSelected = false;
  bool isReleaseSelected = false;
  List<DispoFleetServices> services = [];
  String ubication = "";

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
      return body(context);
    } else if (state is DispoLoading) {
      return const CustomProgress();
    } else if (state is DispoLoaded) {
      return CustomAlert(
          title: "Auto liberado con éxito",
          description:
              "¡El auto ${widget.car.model.toUpperCase()} (${widget.car.plate.toUpperCase()}) se liberó exitosamente!",
          isShowingError: false,
          onPressed: () => Navigator.of(context).pop());
    } else if (state is DispoError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => updateDispo(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => updateDispo(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "Info del auto",
            automaticallyImplyLeading: true,
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
                      if (isDocumentsSelected) ...[documentsWidget(context)],
                      if (isServicesSelected) ...[
                        servicesWidget(context),
                      ],
                      if (isReleaseSelected) ...[
                        ubicationWidget(context),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isShowingAlert) ...[
          const Spacer(),
          CustomMessage(
              isShowingAlert: isShowingAlert, description: TEXT_ALERT),
        ],
      ],
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
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
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
                    isDocumentsSelected = false;
                    isServicesSelected = false;
                    isReleaseSelected = false;
                  });
                }),
              ),
              const SizedBox(width: 15),
              if (widget.car.documents.isNotEmpty) ...[
                CustomElevatedButton(
                  text: "Imágenes",
                  icon: Icons.image_rounded,
                  isSelected: isDocumentsSelected,
                  onPressed: (() {
                    setState(() {
                      isInfoSelected = false;
                      isDocumentsSelected = true;
                      isServicesSelected = false;
                      isReleaseSelected = false;
                    });
                  }),
                ),
                const SizedBox(width: 15),
              ],
              CustomElevatedButton(
                text: "Servicios",
                icon: Icons.build_rounded,
                isSelected: isServicesSelected,
                onPressed: (() {
                  setState(() {
                    isInfoSelected = false;
                    isDocumentsSelected = false;
                    isServicesSelected = true;
                    isReleaseSelected = false;
                  });
                }),
              ),
              if (!widget.car.isReleased) ...[
                const SizedBox(width: 15),
                CustomElevatedButton(
                  text: "Liberar",
                  icon: Icons.directions_car_rounded,
                  isSelected: isReleaseSelected,
                  onPressed: (() {
                    setState(() {
                      isInfoSelected = false;
                      isDocumentsSelected = false;
                      isServicesSelected = false;
                      isReleaseSelected = true;
                    });
                  }),
                ),
              ],
            ],
          ),
        ));
  }

  Widget infoWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 420,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView(
            children: [
              if (!widget.car.isReleased) ...[
                CardDispoInfo(
                    title: "Tiempo para finalización",
                    description: getDays() > 1
                        ? "${getDays()} días"
                        : getDays() == 1
                            ? "Mañana"
                            : getDays() == 0
                                ? "Hoy"
                                : "Contrato finalizado",
                    background: COLOR_RED,
                    icon: Icons.today_rounded),
                CardDispoInfo(
                    title: "Inicio último contrato",
                    description: widget.car.startDate,
                    background: COLOR_BLUE,
                    icon: Icons.calendar_month_rounded),
                CardDispoInfo(
                    title: "Fin último contrato",
                    description: widget.car.endDate,
                    background: COLOR_GREEN,
                    icon: Icons.calendar_month_rounded),
                CardDispoInfo(
                    title: "Empresa",
                    description: widget.car.customer,
                    background: COLOR_ORANGE,
                    icon: Icons.people_rounded),
                CardDispoInfo(
                    title: "Conductor",
                    description: widget.car.driver,
                    background: COLOR_RED,
                    icon: Icons.sports_motorsports_rounded),
              ],
              CardDispoInfo(
                  title: "Deudas de patentes",
                  description: widget.car.debtsPlate,
                  background: COLOR_BLUE,
                  icon: Icons.monetization_on_outlined),
              CardDispoInfo(
                  title: "Deudas de infracciones",
                  description: widget.car.debtsInfractions,
                  background: COLOR_ORANGE,
                  icon: Icons.monetization_on_outlined),
              if (widget.car.isReleased) ...[
                CardDispoInfo(
                    title: "Ubicación",
                    description: widget.car.ubication,
                    background: COLOR_RED,
                    icon: Icons.pin_drop_rounded),
              ],
              CardDispoInfo(
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

  Widget documentsWidget(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 420,
        alignment: Alignment.centerLeft,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.car.documents.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 15,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ROUTE_DISPO_DETAIL_IMAGE_SCREEN,
                        arguments: widget.car.documents[index]);
                  },
                  child: CardDispoImage(image: widget.car.documents[index]));
            },
          ),
        ));
  }

  Widget servicesWidget(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 420,
      child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView.builder(
              itemCount: widget.car.services.length,
              itemBuilder: (BuildContext context, int index) {
                return CardDispoServices(
                    service: widget.car.services[index],
                    carKilometres: widget.car.kilometres,
                    background: COLOR_RED,
                    icon: Icons.tire_repair_rounded);
              })),
    );
  }

  Widget ubicationWidget(BuildContext context) {
    return CustomTextField(
      title: "Ubicación",
      hint: "Ingresá la ubicación",
      icon: Icons.pin_drop_rounded,
      onChanged: (value) {
        setState(() {
          ubication = value;
        });
      },
    );
  }

  Widget floatingButtonWidget(BuildContext context) {
    return Visibility(
        visible: isReleaseSelected,
        child: FloatingActionButton.extended(
          elevation: 12,
          backgroundColor: COLOR_MAGENTA,
          onPressed: () {
            setState(() {
              if (ubication.isEmpty) {
                isShowingAlert = true;
                Future.delayed(const Duration(milliseconds: 3000), () {
                  setState(() {
                    isShowingAlert = false;
                  });
                });
              } else {
                showAlertDialog(
                    context,
                    "¿Confirmás la liberación del auto ${widget.car.model.toUpperCase()} (${widget.car.plate.toUpperCase()})?",
                    "Si confirmás la acción no se puede volver atrás...",
                    "LIBERAR");
              }
            });
          },
          label: Row(
            children: const [
              Icon(
                Icons.check_rounded,
                color: COLOR_WHITE,
                size: SIZE_ICON_ONE,
              ),
              SizedBox(
                width: 5,
              ),
              Text(TEXT_RELEASE),
            ],
          ),
        ));
  }

  int getDays() {
    String currentDate = DateFormat("dd/MM/yy").format(DateTime.now());
    String currentHour = DateFormat("Hm").format(DateTime.now());
    String fromEdited =
        "20${currentDate.substring(6, 8)}-${currentDate.substring(3, 5)}-${currentDate.substring(0, 2)} $currentHour:00.000000";
    String toEdited =
        "20${widget.car.endDate.substring(6, 8)}-${widget.car.endDate.substring(3, 5)}-${widget.car.endDate.substring(0, 2)} 00:00:00.000000";
    DateTime from = DateTime.parse(fromEdited);
    DateTime to = DateTime.parse(toEdited);

    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
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
          updateDispo(context);
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

  Future<void> updateDispo(BuildContext context) async {
    BlocProvider.of<DispoCubit>(context)
        .updateDispo(id: widget.car.fleetId, ubication: ubication);
  }
}
