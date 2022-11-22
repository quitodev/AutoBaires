import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/fleet/fleet.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/fleet/fleet_cubit.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FleetServicesScreen extends StatefulWidget {
  const FleetServicesScreen({Key? key, required this.args}) : super(key: key);

  final FleetArguments args;

  static const String routeName = ROUTE_FLEET_SERVICES_SCREEN;

  static Route route({required FleetArguments args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => FleetServicesScreen(args: args),
    );
  }

  @override
  State<FleetServicesScreen> createState() => _FleetServicesScreenState();
}

class _FleetServicesScreenState extends State<FleetServicesScreen> {
  String job = "";
  String provider = "";
  String kilometres = "";
  String comments = "";
  String date = "";
  bool isEditing = false;

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
          title: "Servicio actualizado con éxito",
          description:
              "¡El servicio de ${widget.args.service.job} se actualizó exitosamente!",
          isShowingError: false,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
    } else if (state is FleetError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => updateServices(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => updateServices(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Info de servicios",
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: floatingButtonWidget(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              jobWidget(context),
              const SizedBox(
                height: 30,
              ),
              dateWidget(context),
              providerWidget(context),
              const SizedBox(
                height: 30,
              ),
              kilometresWidget(context),
              const SizedBox(
                height: 30,
              ),
              commentsWidget(context),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget jobWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.build_rounded,
              color: COLOR_MAGENTA,
              size: SIZE_ICON_ONE,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Nombre del servicio",
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
          text: job.isEmpty ? widget.args.service.job : job,
          isSelected: false,
        ),
      ],
    );
  }

  Widget dateWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Seleccioná la fecha de reparación",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_ONE,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: getFormatDates(widget.args.service.date),
            onSelectionChanged: onSelectionChanged,
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Fecha de reparación",
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
            text: date.isEmpty ? widget.args.service.date : date,
            isSelected: false,
          ),
        ],
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget providerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Nombre del taller mecánico",
            hint: provider.isEmpty ? widget.args.service.provider : provider,
            icon: Icons.tire_repair_rounded,
            onChanged: (value) {
              setState(() {
                provider = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
          Row(
            children: [
              const Icon(
                Icons.tire_repair_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Nombre del taller mecánico",
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
            text: provider.isEmpty ? widget.args.service.provider : provider,
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
            title: widget.args.service.job == TEXT_SERVICE_KILOMETRAJE
                ? "Kilometraje en tablero"
                : "Kilometrate al momento de la reparación",
            hint: kilometres.isEmpty
                ? "${widget.args.service.kilometres}"
                : kilometres,
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
                widget.args.service.job == TEXT_SERVICE_KILOMETRAJE
                    ? "Kilometraje en tablero"
                    : "Kilometrate al momento de la reparación",
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
            text: kilometres.isEmpty
                ? "${widget.args.service.kilometres}"
                : kilometres,
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
            title: "Comentarios",
            hint: widget.args.service.comments == EMPTY
                ? "Ingresá algún comentario"
                : widget.args.service.comments,
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
            text: comments.isEmpty
                ? widget.args.service.comments == EMPTY
                    ? NO_COMMENTS
                    : widget.args.service.comments
                : comments,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget floatingButtonWidget(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 12,
      backgroundColor: COLOR_MAGENTA,
      onPressed: () {
        setState(() {
          if (isEditing) {
            isEditing = false;
            job = job.isEmpty ? widget.args.service.job : job;
            provider =
                provider.isEmpty ? widget.args.service.provider : provider;
            kilometres = kilometres.isEmpty
                ? "${widget.args.service.kilometres}"
                : kilometres;
            comments =
                comments.isEmpty ? widget.args.service.comments : comments;
            date = date.isEmpty ? widget.args.service.date : date;
            updateServices(context);
          } else {
            isEditing = true;
          }
        });
      },
      label: Row(
        children: [
          Icon(
            isEditing ? Icons.save_rounded : Icons.edit_rounded,
            color: COLOR_WHITE,
            size: SIZE_ICON_ONE,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(isEditing ? TEXT_SAVE : TEXT_MODIFY),
        ],
      ),
    );
  }

  DateTime getFormatDates(String date) {
    String dateEdited =
        "20${date.substring(6, 8)}-${date.substring(3, 5)}-${date.substring(0, 2)} 00:00:00.000000";
    DateTime newDate = DateTime.parse(dateEdited);
    return newDate;
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      setState(() {
        date = DateFormat("dd/MM/yy").format(args.value);
      });
    }
  }

  List<FleetServices> getServices() {
    List<FleetServices> list = widget.args.car.services
        .cast<FleetServices>()
        .map((service) => FleetServices(
            comments: service.job == job ? comments : service.comments,
            date: service.job == job ? date : service.date,
            job: service.job == job ? job : service.job,
            kilometres:
                service.job == job ? int.parse(kilometres) : service.kilometres,
            provider: service.job == job ? provider : service.provider))
        .toList();
    return list;
  }

  Future<void> updateServices(BuildContext context) async {
    BlocProvider.of<FleetCubit>(context)
        .updateServices(id: widget.args.car.id, services: getServices());
  }
}
