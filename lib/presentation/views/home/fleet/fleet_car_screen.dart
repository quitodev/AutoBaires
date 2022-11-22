import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/fleet/fleet.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/fleet/fleet_cubit.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_message.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FleetCarScreen extends StatefulWidget {
  const FleetCarScreen({Key? key, this.car}) : super(key: key);

  final Fleet? car;

  static const String routeName = ROUTE_FLEET_CAR_SCREEN;

  static Route route({Fleet? car}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => FleetCarScreen(car: car),
    );
  }

  @override
  State<FleetCarScreen> createState() => _FleetCarScreenState();
}

class _FleetCarScreenState extends State<FleetCarScreen> {
  String model = "";
  String plate = "";
  String kilometres = "";
  String debtsInfractions = "";
  String debtsPlate = "";
  String ubication = "";
  String comments = "";
  bool isEditing = true;
  bool isShowingAlert = false;
  Fleet? newCar;

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
          title: widget.car == null
              ? "Auto agregado con éxito"
              : "Auto modificado con éxito",
          description: widget.car == null
              ? "¡El auto ${model.toUpperCase()} (${plate.toUpperCase()}) fue dado de alta exitosamente!"
              : "¡El auto ${model.toUpperCase()} (${plate.toUpperCase()}) fue modificado exitosamente!",
          isShowingError: false,
          onPressed: () {
            if (widget.car == null) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          });
    } else if (state is FleetError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () =>
              widget.car == null ? createFleet(context) : updateFleet(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () =>
              widget.car == null ? createFleet(context) : updateFleet(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: widget.car == null ? "Nuevo auto" : "Modificar auto",
            automaticallyImplyLeading: true,
          ),
          floatingActionButton: floatingButtonWidget(context),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  modelWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  plateWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  kilometresWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  debtsPlateWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  debtsInfractionsWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  ubicationWidget(context),
                  const SizedBox(
                    height: 30,
                  ),
                  commentsWidget(context),
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
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

  Widget modelWidget(BuildContext context) {
    return Column(
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Modelo",
            hint: widget.car?.model ?? "Ingresá el modelo",
            icon: Icons.directions_car_rounded,
            onChanged: (value) {
              setState(() {
                model = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.directions_car_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Modelo",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: model,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget plateWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Patente",
            hint: widget.car?.plate ?? "Ingresá la patente",
            icon: Icons.keyboard_rounded,
            onChanged: (value) {
              setState(() {
                plate = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.keyboard_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Patente",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: plate,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget kilometresWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Kilometraje",
            hint: widget.car?.kilometres == null
                ? "Ingresá el kilometraje"
                : "${widget.car!.kilometres}",
            icon: Icons.speed_rounded,
            inputType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                kilometres = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.speed_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Kilometraje",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: kilometres,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget debtsPlateWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Deudas de patentes",
            hint: widget.car?.debtsPlate == null
                ? "Ingresá las deudas"
                : widget.car!.debtsPlate,
            icon: Icons.monetization_on_outlined,
            onChanged: (value) {
              setState(() {
                debtsPlate = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Deudas de patentes",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: debtsPlate,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget debtsInfractionsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Deudas de infracciones",
            hint: widget.car?.debtsInfractions == null
                ? "Ingresá las deudas"
                : widget.car!.debtsInfractions,
            icon: Icons.monetization_on_outlined,
            onChanged: (value) {
              setState(() {
                debtsInfractions = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Deudas de infracciones",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: debtsInfractions,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget ubicationWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Ubicación",
            hint: widget.car?.ubication ?? "Ingresá la ubicación",
            icon: Icons.pin_drop_rounded,
            onChanged: (value) {
              setState(() {
                ubication = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.pin_drop_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Ubicación",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: ubication,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget commentsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title:
                widget.car == null ? "Comentarios (opcional)" : "Comentarios",
            hint: widget.car?.comments == EMPTY
                ? "Ingresá algún comentario"
                : widget.car?.comments ?? "Ingresá algún comentario",
            icon: Icons.comment_rounded,
            onChanged: (value) {
              setState(() {
                comments = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.comment_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Comentarios",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK_LIGHT),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            text: comments.isEmpty ? NO_COMMENTS : comments,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget floatingButtonWidget(BuildContext context) {
    return Visibility(
      visible: !isShowingAlert,
      child: FloatingActionButton.extended(
        elevation: 12,
        backgroundColor: COLOR_MAGENTA,
        onPressed: () {
          setState(() {
            model = model.isNotEmpty ? model : widget.car?.model ?? "";
            plate = plate.isNotEmpty ? plate : widget.car?.plate ?? "";
            kilometres = kilometres.isNotEmpty
                ? kilometres
                : widget.car?.kilometres.toString() ?? "";
            debtsPlate = debtsPlate.isNotEmpty
                ? debtsPlate
                : widget.car?.debtsPlate ?? "";
            debtsInfractions = debtsInfractions.isNotEmpty
                ? debtsInfractions
                : widget.car?.debtsInfractions ?? "";
            ubication =
                ubication.isNotEmpty ? ubication : widget.car?.ubication ?? "";
            comments =
                comments.isNotEmpty ? comments : widget.car?.comments ?? "";

            if (model.isEmpty ||
                plate.isEmpty ||
                kilometres.isEmpty ||
                debtsPlate.isEmpty ||
                debtsInfractions.isEmpty ||
                ubication.isEmpty) {
              isShowingAlert = true;
              Future.delayed(const Duration(milliseconds: 3000), () {
                setState(() {
                  isShowingAlert = false;
                });
              });
            } else {
              isEditing = false;
              newCar = Fleet(
                comments: comments.isEmpty ? EMPTY : comments,
                contractId: widget.car == null ? EMPTY : widget.car!.contractId,
                customerId: widget.car == null ? EMPTY : widget.car!.customerId,
                debtsInfractions: debtsInfractions,
                debtsPlate: debtsPlate,
                id: widget.car == null
                    ? UniqueKey().toString()
                    : widget.car!.id,
                image: widget.car == null ? IMAGE_DISPO : widget.car!.image,
                isDeleted: false,
                isReleased: widget.car == null ? true : widget.car!.isReleased,
                kilometres: int.tryParse(kilometres) ?? 0,
                model: model,
                plate: plate,
                services: widget.car == null
                    ? getServices(int.tryParse(kilometres) ?? 0)
                    : widget.car!.services,
                ubication: ubication,
              );
              widget.car == null ? createFleet(context) : updateFleet(context);
            }
          });
        },
        label: Row(
          children: const [
            Icon(
              Icons.save_rounded,
              color: COLOR_WHITE,
              size: SIZE_ICON_ONE,
            ),
            SizedBox(
              width: 5,
            ),
            Text(TEXT_SAVE),
          ],
        ),
      ),
    );
  }

  List<FleetServices> getServices(int kilometres) {
    List<FleetServices> list = [];
    List<String> jobs = [
      TEXT_SERVICE_ACEITE,
      TEXT_SERVICE_BATERIA,
      TEXT_SERVICE_CEDULA,
      TEXT_SERVICE_CORREA,
      TEXT_SERVICE_CUBIERTAS,
      TEXT_SERVICE_DISCOS_DEL,
      TEXT_SERVICE_DISCOS_TRA,
      TEXT_SERVICE_FRENO_DEL,
      TEXT_SERVICE_FRENO_TRA,
      TEXT_SERVICE_KILOMETRAJE,
      TEXT_SERVICE_VTV,
    ];
    list = jobs.map((job) {
      return FleetServices(
          comments: "¡Actualizar datos del service!",
          date: DateFormat("dd/MM/yy").format(DateTime.now()),
          job: job,
          kilometres: 0,
          provider:
              job == TEXT_SERVICE_CEDULA || job == TEXT_SERVICE_KILOMETRAJE
                  ? "No aplica"
                  : "Sin taller");
    }).toList();
    return list;
  }

  void createFleet(BuildContext context) async {
    BlocProvider.of<FleetCubit>(context).createFleet(car: newCar!);
  }

  void updateFleet(BuildContext context) async {
    BlocProvider.of<FleetCubit>(context).updateFleet(car: newCar!);
  }
}
