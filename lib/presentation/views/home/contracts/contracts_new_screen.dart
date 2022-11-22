import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/contracts/contracts.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/contracts/contracts_cubit.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_message.dart';
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

class ContractsNewScreen extends StatefulWidget {
  const ContractsNewScreen({Key? key, required this.contract})
      : super(key: key);

  final Contracts contract;

  static const String routeName = ROUTE_CONTRACTS_NEW_SCREEN;

  static Route route({required Contracts contract}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ContractsNewScreen(contract: contract),
    );
  }

  @override
  State<ContractsNewScreen> createState() => _ContractsNewScreenState();
}

class _ContractsNewScreenState extends State<ContractsNewScreen> {
  bool isShowingAlert = false;
  String car = "";
  String carId = "";
  String plate = "";
  String customer = "";
  String customerId = "";
  String driver = "";
  String startDate = "";
  String endDate = "";
  String endTime = "";
  String fileName = "";
  String filePath = "";
  String comments = "";
  late ContractsContracts newContract;

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
      return CustomAlert(
          title: "Contrato agregado con éxito",
          description:
              "¡El contrato #${int.parse(widget.contract.id) + 1} se dio de alta exitosamente!",
          isShowingError: false,
          onPressed: () => Navigator.of(context).pop());
    } else if (state is ContractsError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => createContracts(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => createContracts(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "Nuevo contrato",
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
                  if (car.isNotEmpty) ...[
                    plateWidget(context),
                  ],
                  const SizedBox(
                    height: 30,
                  ),
                  if (plate.isNotEmpty) ...[
                    customersWidget(context),
                  ],
                  if (customer.isNotEmpty) ...[
                    driversWidget(context),
                  ],
                  if (driver.isNotEmpty) ...[
                    dateWidget(context),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                  if (endDate.isNotEmpty) ...[
                    timeWidget(context),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                  if (kIsWeb) ...[
                    if (endTime.isNotEmpty) ...[
                      commentsWidget(context),
                    ],
                  ],
                  if (!kIsWeb) ...[
                    if (endTime.isNotEmpty) ...[
                      documentsWidget(context),
                    ],
                    if (fileName.isNotEmpty) ...[
                      commentsWidget(context),
                    ],
                  ],
                  const SizedBox(
                    height: 80,
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
              "Seleccioná un auto",
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
        Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.contract.models.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        CustomElevatedButton(
                          text: widget.contract.models[index],
                          isSelected: widget.contract.models[index] == car,
                          onPressed: (() {
                            setState(() {
                              car = widget.contract.models[index];
                              plate = "";
                              customer = "";
                              driver = "";
                              endDate = "";
                              endTime = "";
                            });
                          }),
                        ),
                      ],
                    );
                  }),
            )),
      ],
    );
  }

  Widget plateWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              "Seleccioná una patente",
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
        Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.contract.cars
                      .where((e) => e.model == car)
                      .toList()
                      .length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        CustomElevatedButton(
                          text: widget.contract.cars
                              .where((e) => e.model == car)
                              .toList()[index]
                              .plate
                              .toUpperCase(),
                          isSelected: widget.contract.cars
                                  .where((e) => e.model == car)
                                  .toList()[index]
                                  .plate
                                  .toUpperCase() ==
                              plate,
                          onPressed: (() {
                            setState(() {
                              plate = widget.contract.cars
                                  .where((e) => e.model == car)
                                  .toList()[index]
                                  .plate;
                              carId = widget.contract.cars
                                  .where((e) => e.model == car)
                                  .toList()[index]
                                  .id;
                              customer = "";
                              driver = "";
                              endDate = "";
                              endTime = "";
                            });
                          }),
                        ),
                      ],
                    );
                  }),
            )),
      ],
    );
  }

  Widget customersWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.people_rounded,
              color: COLOR_MAGENTA,
              size: SIZE_ICON_ONE,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Seleccioná una empresa",
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
        Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.contract.customers
                      .where((customer) => !customer.isDeleted)
                      .toList()
                      .length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        CustomElevatedButton(
                          text: widget.contract.customers
                              .where((customer) => !customer.isDeleted)
                              .toList()[index]
                              .customer,
                          isSelected: widget.contract.customers
                                  .where((customer) => !customer.isDeleted)
                                  .toList()[index]
                                  .customer ==
                              customer,
                          onPressed: (() {
                            setState(() {
                              customer = widget.contract.customers
                                  .where((customer) => !customer.isDeleted)
                                  .toList()[index]
                                  .customer;
                              customerId = widget.contract.customers
                                  .where((customer) => !customer.isDeleted)
                                  .toList()[index]
                                  .id;
                              driver = "";
                              endDate = "";
                              endTime = "";
                            });
                          }),
                        ),
                      ],
                    );
                  }),
            )),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget driversWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.sports_motorsports_rounded,
              color: COLOR_MAGENTA,
              size: SIZE_ICON_ONE,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              "Seleccioná un conductor",
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
        Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.contract.customers
                      .where((element) => element.customer == customer)
                      .toList()
                      .first
                      .drivers
                      .toSet()
                      .toList()
                      .length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        CustomElevatedButton(
                          text: widget.contract.customers
                              .where((element) => element.customer == customer)
                              .toList()
                              .first
                              .drivers
                              .toSet()
                              .toList()[index],
                          isSelected: widget.contract.customers
                                  .where(
                                      (element) => element.customer == customer)
                                  .toList()
                                  .first
                                  .drivers
                                  .toSet()
                                  .toList()[index] ==
                              driver,
                          onPressed: (() {
                            setState(() {
                              driver = widget.contract.customers
                                  .where(
                                      (element) => element.customer == customer)
                                  .toList()
                                  .first
                                  .drivers
                                  .toSet()
                                  .toList()[index];
                            });
                          }),
                        ),
                      ],
                    );
                  }),
            )),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget dateWidget(BuildContext context) {
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
              "Seleccioná la finalización del contrato",
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
        const SizedBox(
          height: 10,
        ),
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: onSelectionChanged,
        ),
      ],
    );
  }

  Widget timeWidget(BuildContext context) {
    return CustomTextField(
      title: "Hora de devolución",
      hint: "Ingresá la hora de devolución",
      icon: Icons.schedule_sharp,
      onChanged: (value) {
        setState(() {
          endTime = value;
        });
      },
    );
  }

  Widget documentsWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              "Seleccioná la foto del contrato",
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
        const SizedBox(
          height: 10,
        ),
        CustomElevatedButton(
          text: fileName.isEmpty ? "Tocá para elegir" : "Foto cargada",
          icon: fileName.isEmpty ? Icons.cancel : Icons.check_circle,
          isSelected: fileName.isNotEmpty,
          onPressed: (() async {
            setState(() {
              fileName = "";
              filePath = "";
              selectFile(context);
            });
          }),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget commentsWidget(BuildContext context) {
    return CustomTextField(
      title: "Comentarios (opcional)",
      hint: "Ingresá algún comentario",
      icon: Icons.comment_rounded,
      onChanged: (value) {
        setState(() {
          comments = value;
        });
      },
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
            if (car.isEmpty ||
                customer.isEmpty ||
                driver.isEmpty ||
                startDate.isEmpty ||
                endDate.isEmpty ||
                endTime.isEmpty) {
              isShowingAlert = true;
              Future.delayed(const Duration(milliseconds: 3000), () {
                setState(() {
                  isShowingAlert = false;
                });
              });
            } else {
              List<String> documents = [];
              newContract = ContractsContracts(
                  comments: comments.isEmpty ? EMPTY : comments,
                  customerId: customerId,
                  documents: documents,
                  driver: driver,
                  endDate: "$endDate $endTime",
                  fleetId: carId,
                  fleetIdNew: EMPTY,
                  id: "${int.parse(widget.contract.id) + 1}",
                  isDeleted: false,
                  isFinished: false,
                  isReplaced: false,
                  startDate: startDate);
              createContracts(context);
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

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime) {
      setState(() {
        startDate =
            "${DateFormat("dd/MM/yy").format(DateTime.now())} ${DateFormat("Hm").format(DateTime.now())}";
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

  void createContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context).createContracts(
        contract: newContract, fileName: fileName, filePath: filePath);
  }
}
