import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/contracts/contracts.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/contracts/contracts_cubit.dart';
import 'package:autobaires/presentation/views/home/contracts/widgets/card_contracts_image.dart';
import 'package:autobaires/presentation/views/home/contracts/widgets/card_contracts_info.dart';
import 'package:autobaires/presentation/views/home/contracts/widgets/card_contracts_replace.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ContractsDetailScreen extends StatefulWidget {
  const ContractsDetailScreen({Key? key, required this.contract})
      : super(key: key);

  final Contracts contract;

  static const String routeName = ROUTE_CONTRACTS_DETAIL_SCREEN;

  static Route route({required Contracts contract}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ContractsDetailScreen(contract: contract),
    );
  }

  @override
  State<ContractsDetailScreen> createState() => _ContractsDetailScreenState();
}

class _ContractsDetailScreenState extends State<ContractsDetailScreen> {
  bool isShowingAlert = false;
  bool isInfoSelected = true;
  bool isDocumentsSelected = false;
  bool isReplaceSelected = false;
  bool isExtendSelected = false;
  bool isFinishSelected = false;
  bool isDeleteSelected = false;
  String endDate = "";
  String endTime = "";
  String fleetIdNew = "";
  String fileName = "";
  String filePath = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.data?.getBool(TEXT_SHARED) ?? false) {
            return BlocProvider(
              create: (_) => sl<ContractsCubit>(),
              child: BlocBuilder<ContractsCubit, ContractsState>(
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

  Widget stateManagement(BuildContext context, ContractsState state) {
    if (state is ContractsInitial) {
      return body(context);
    } else if (state is ContractsLoading) {
      return const CustomProgress();
    } else if (state is ContractsLoaded) {
      if (isReplaceSelected) {
        return CustomAlert(
            title: "Auto reemplazado con éxito",
            description:
                "¡El auto ${widget.contract.model.toUpperCase()} se reemplazó exitosamente!",
            isShowingError: false,
            onPressed: () => Navigator.of(context).pop());
      } else if (isExtendSelected) {
        return CustomAlert(
            title: "Contrato extendido con éxito",
            description:
                "¡El contrato #${widget.contract.id} se extendió exitosamente!",
            isShowingError: false,
            onPressed: () => Navigator.of(context).pop());
      } else if (isFinishSelected) {
        return CustomAlert(
            title: "Contrato finalizado con éxito",
            description:
                "¡El contrato #${widget.contract.id} finalizó exitosamente!",
            isShowingError: false,
            onPressed: () => Navigator.of(context).pop());
      } else if (isDeleteSelected) {
        return CustomAlert(
            title: "Contrato eliminado con éxito",
            description:
                "¡El contrato #${widget.contract.id} se eliminó exitosamente!",
            isShowingError: false,
            onPressed: () => Navigator.of(context).pop());
      } else {
        return CustomAlert(
            title: "Imagen agregada con éxito",
            description: "¡La imagen que seleccionaste se agregó exitosamente!",
            isShowingError: false,
            onPressed: () => Navigator.of(context).pop());
      }
    } else if (state is ContractsError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () {
            if (isReplaceSelected) {
              replaceContracts(context);
            } else if (isExtendSelected) {
              extendContracts(context);
            } else if (isFinishSelected) {
              finishContracts(context);
            } else if (isDeleteSelected) {
              deleteContracts(context);
            } else {
              updateContracts(context);
            }
          },
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () {
            if (isReplaceSelected) {
              replaceContracts(context);
            } else if (isExtendSelected) {
              extendContracts(context);
            } else if (isFinishSelected) {
              finishContracts(context);
            } else if (isDeleteSelected) {
              deleteContracts(context);
            } else {
              updateContracts(context);
            }
          },
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Info del contrato",
        automaticallyImplyLeading: true,
        onPressed: () {
          setState(() {
            isInfoSelected = false;
            isDocumentsSelected = false;
            isReplaceSelected = false;
            isExtendSelected = false;
            isFinishSelected = false;
            isDeleteSelected = true;
          });
          showAlertDialog(
              context,
              "¿Eliminás el contrato #${widget.contract.id}?",
              "Si confirmás la acción no se puede volver atrás y se liberará el auto en uso (acordate de actualizar después su ubicación)...",
              "ELIMINAR");
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
                  if (isInfoSelected) ...[infoWidget(context)],
                  if (isDocumentsSelected) ...[documentsWidget(context)],
                  if (isExtendSelected) ...[
                    extendWidget(context),
                  ],
                  if (isReplaceSelected) ...[
                    replaceWidget(context),
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
      widget.contract.isReplaced
          ? "${widget.contract.modelNew.toUpperCase()} (ANTES ${widget.contract.model.toUpperCase()})"
          : widget.contract.model.toUpperCase(),
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
      widget.contract.isReplaced
          ? "${widget.contract.plateNew.toUpperCase()} (ANTES ${widget.contract.plate.toUpperCase()})"
          : widget.contract.plate.toUpperCase(),
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
    return Row(
      children: [
        Text(
          "${NumberFormat("#,##0").format(widget.contract.kilometres)} Km.",
          style: GoogleFonts.roboto(
              fontWeight: WEIGHT_TEXT_ONE,
              fontSize: SIZE_TEXT_TWO,
              color: COLOR_ORANGE),
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
                    isReplaceSelected = false;
                    isExtendSelected = false;
                    isFinishSelected = false;
                    isDeleteSelected = false;
                  });
                }),
              ),
              const SizedBox(width: 15),
              if ((!kIsWeb) ||
                  (kIsWeb && widget.contract.documents.isNotEmpty)) ...[
                CustomElevatedButton(
                  text: "Imágenes",
                  icon: Icons.image_rounded,
                  isSelected: isDocumentsSelected,
                  onPressed: (() {
                    setState(() {
                      isInfoSelected = false;
                      isDocumentsSelected = true;
                      isReplaceSelected = false;
                      isExtendSelected = false;
                      isFinishSelected = false;
                      isDeleteSelected = false;
                    });
                  }),
                ),
                const SizedBox(width: 15),
              ],
              if (getDays() > 0) ...[
                CustomElevatedButton(
                  text: "Sustituir",
                  icon: Icons.sync_rounded,
                  isSelected: isReplaceSelected,
                  onPressed: (() {
                    setState(() {
                      isInfoSelected = false;
                      isDocumentsSelected = false;
                      isReplaceSelected = true;
                      isExtendSelected = false;
                      isFinishSelected = false;
                      isDeleteSelected = false;
                    });
                  }),
                ),
                const SizedBox(width: 15),
                CustomElevatedButton(
                  text: "Extender",
                  icon: Icons.calendar_month_rounded,
                  isSelected: isExtendSelected,
                  onPressed: (() {
                    setState(() {
                      isInfoSelected = false;
                      isDocumentsSelected = false;
                      isReplaceSelected = false;
                      isExtendSelected = true;
                      isFinishSelected = false;
                      isDeleteSelected = false;
                    });
                  }),
                ),
                const SizedBox(width: 15),
                CustomElevatedButton(
                  text: "Finalizar",
                  icon: Icons.content_cut_rounded,
                  isSelected: isFinishSelected,
                  onPressed: (() {
                    setState(() {
                      isInfoSelected = false;
                      isDocumentsSelected = false;
                      isReplaceSelected = false;
                      isExtendSelected = false;
                      isFinishSelected = true;
                      isDeleteSelected = false;
                    });
                    showAlertDialog(
                        context,
                        "¿Finalizás el contrato #${widget.contract.id}?",
                        "Si confirmás la acción no se puede volver atrás y se liberará el auto en uso (acordate de actualizar después su ubicación)...",
                        "FINALIZAR");
                  }),
                ),
              ],
            ],
          ),
        ));
  }

  Widget infoWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height - 420,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView(
                children: [
                  CardContractsInfo(
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
                  CardContractsInfo(
                      title: "Inicio de contrato",
                      description: widget.contract.startDate,
                      background: COLOR_BLUE,
                      icon: Icons.calendar_month_rounded),
                  CardContractsInfo(
                      title: "Fin de contrato",
                      description: widget.contract.endDate,
                      background: COLOR_GREEN,
                      icon: Icons.calendar_month_rounded),
                  CardContractsInfo(
                      title: "Empresa",
                      description: widget.contract.customer,
                      background: COLOR_ORANGE,
                      icon: Icons.people_rounded),
                  CardContractsInfo(
                      title: "Conductor",
                      description: widget.contract.driver,
                      background: COLOR_RED,
                      icon: Icons.sports_motorsports_rounded),
                  CardContractsInfo(
                      title: "Comentarios",
                      description: widget.contract.comments == EMPTY
                          ? NO_COMMENTS
                          : widget.contract.comments,
                      background: COLOR_AQUA,
                      icon: Icons.comment_rounded),
                ],
              ),
            )),
      ],
    );
  }

  Widget documentsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!kIsWeb) ...[
          Row(
            children: [
              const Icon(
                Icons.image_rounded,
                color: COLOR_MAGENTA,
                size: SIZE_ICON_ONE,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                fileName.isEmpty
                    ? "Tocá en Agregar para subir una imagen..."
                    : "Ahora tocá en Guardar y listo!",
                style: GoogleFonts.roboto(
                    fontWeight: WEIGHT_TEXT_TWO,
                    fontSize: SIZE_TEXT_TWO,
                    color: COLOR_BLACK),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        Container(
            height: MediaQuery.of(context).size.height - 420,
            alignment: Alignment.centerLeft,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.contract.documents.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 15,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ROUTE_CONTRACTS_DETAIL_IMAGE_SCREEN,
                            arguments: widget.contract.documents[index]);
                      },
                      child: CardContractsImage(
                        image: widget.contract.documents[index],
                      ));
                },
              ),
            ))
      ],
    );
  }

  Widget extendWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              "Elegí hasta qué día se extiende...",
              style: GoogleFonts.roboto(
                  fontWeight: WEIGHT_TEXT_TWO,
                  fontSize: SIZE_TEXT_TWO,
                  color: COLOR_BLACK),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: getFormatDates(widget.contract.endDate),
          onSelectionChanged: onSelectionChanged,
        ),
        const SizedBox(
          height: 30,
        ),
        if (endDate.isNotEmpty) ...[
          CustomTextField(
            title: "Hora de devolución",
            hint: "Ingresá la hora de devolución",
            icon: Icons.schedule_sharp,
            onChanged: (value) {
              setState(() {
                endTime = value;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ],
    );
  }

  Widget replaceWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              "Elegí el nuevo auto para sustituir...",
              style: GoogleFonts.roboto(
                  fontWeight: WEIGHT_TEXT_TWO,
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
        SizedBox(
            height: MediaQuery.of(context).size.height - 450,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                  itemCount: widget.contract.fleetIdNew == EMPTY
                      ? widget.contract.cars
                          .where((car) =>
                              car.isReleased &&
                              car.id != widget.contract.fleetId)
                          .toList()
                          .length
                      : widget.contract.cars
                          .where((car) =>
                              car.isReleased &&
                              car.id != widget.contract.fleetIdNew)
                          .toList()
                          .length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          final carSelected =
                              widget.contract.fleetIdNew == EMPTY
                                  ? widget.contract.cars
                                      .where((car) =>
                                          car.isReleased &&
                                          car.id != widget.contract.fleetId)
                                      .toList()[index]
                                  : widget.contract.cars
                                      .where((car) =>
                                          car.isReleased &&
                                          car.id != widget.contract.fleetIdNew)
                                      .toList()[index];
                          fleetIdNew = carSelected.id;
                          showAlertDialog(
                              context,
                              "¿Confirmás la sustitución por el ${carSelected.model.toUpperCase()} (${carSelected.plate.toUpperCase()})?",
                              "Si confirmás la acción no se puede volver atrás y se liberará el auto original (acordate de actualizar después su ubicación)...",
                              "SUSTITUIR");
                        },
                        child: CardContractsReplace(
                            car: widget.contract.fleetIdNew == EMPTY
                                ? widget.contract.cars
                                    .where((car) =>
                                        car.isReleased &&
                                        car.id != widget.contract.fleetId)
                                    .toList()[index]
                                : widget.contract.cars
                                    .where((car) =>
                                        car.isReleased &&
                                        car.id != widget.contract.fleetIdNew)
                                    .toList()[index]));
                  }),
            )),
      ],
    );
  }

  Widget floatingButtonWidget(BuildContext context) {
    return Visibility(
      visible: (isExtendSelected && endTime.isNotEmpty) ||
          (isDocumentsSelected && !kIsWeb),
      child: FloatingActionButton.extended(
        elevation: 12,
        backgroundColor: COLOR_MAGENTA,
        onPressed: () {
          setState(() {
            if (isExtendSelected) {
              showAlertDialog(
                  context,
                  "¿Confirmás la extensión al $endDate?",
                  "Si confirmás la acción no se puede volver atrás...",
                  "EXTENDER");
            } else {
              fileName.isEmpty ? selectFile(context) : updateContracts(context);
            }
          });
        },
        label: Row(
          children: [
            Icon(
              isExtendSelected
                  ? Icons.save_rounded
                  : fileName.isEmpty
                      ? Icons.add_a_photo_rounded
                      : Icons.save_rounded,
              color: COLOR_WHITE,
              size: SIZE_ICON_ONE,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(isExtendSelected
                ? TEXT_SAVE
                : fileName.isEmpty
                    ? TEXT_ADD
                    : TEXT_SAVE),
          ],
        ),
      ),
    );
  }

  int getDays() {
    String currentDate = DateFormat("dd/MM/yy").format(DateTime.now());
    String currentHour = DateFormat("Hm").format(DateTime.now());
    String fromEdited =
        "20${currentDate.substring(6, 8)}-${currentDate.substring(3, 5)}-${currentDate.substring(0, 2)} $currentHour:00.000000";
    String toEdited =
        "20${widget.contract.endDate.substring(6, 8)}-${widget.contract.endDate.substring(3, 5)}-${widget.contract.endDate.substring(0, 2)} 00:00:00.000000";
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
        setState(() {
          if (isFinishSelected || isDeleteSelected) {
            isInfoSelected = true;
            isReplaceSelected = false;
            isExtendSelected = false;
            isFinishSelected = false;
            isDeleteSelected = false;
          }
        });
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(confirm),
      onPressed: () {
        setState(() {
          if (isReplaceSelected) {
            replaceContracts(context);
          } else if (isExtendSelected) {
            extendContracts(context);
          } else if (isFinishSelected) {
            finishContracts(context);
          } else if (isDeleteSelected) {
            deleteContracts(context);
          } else {
            updateContracts(context);
          }
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

  DateTime getFormatDates(String date) {
    String dateEdited =
        "20${date.substring(6, 8)}-${date.substring(3, 5)}-${date.substring(0, 2)} 00:00:00.000000";
    DateTime newDate = DateTime.parse(dateEdited);
    return newDate;
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      setState(() {
        endDate = DateFormat("dd/MM/yy").format(args.value);
      });
    }
  }

  void selectFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["jpg", "png"],
    );
    if (result != null) {
      setState(() {
        fileName = UniqueKey().toString();
        filePath = result.files.single.path!;
      });
    }
  }

  void replaceContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context).replaceContracts(
        id: widget.contract.id,
        fleetId: widget.contract.fleetId,
        fleetIdNew: fleetIdNew,
        customerId: widget.contract.customerId);
  }

  void extendContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context)
        .extendContracts(id: widget.contract.id, endDate: "$endDate $endTime");
  }

  void finishContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context).finishContracts(
        id: widget.contract.id,
        fleetId: widget.contract.fleetIdNew == EMPTY
            ? widget.contract.fleetId
            : widget.contract.fleetIdNew,
        endDate:
            "${DateFormat("dd/MM/yy").format(DateTime.now())} ${DateFormat("HH:mm").format(DateTime.now())}");
  }

  void deleteContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context).deleteContracts(
        id: widget.contract.id,
        fleetId: widget.contract.fleetIdNew == EMPTY
            ? widget.contract.fleetId
            : widget.contract.fleetIdNew);
  }

  void updateContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context).updateContracts(
        id: widget.contract.id, fileName: fileName, filePath: filePath);
  }
}
