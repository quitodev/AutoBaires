import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/customers/customers_cubit.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersDetailScreen extends StatefulWidget {
  const CustomersDetailScreen({Key? key, required this.customer})
      : super(key: key);

  final Customers customer;

  static const String routeName = ROUTE_CUSTOMERS_DETAIL_SCREEN;

  static Route route({required Customers customer}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => CustomersDetailScreen(customer: customer),
    );
  }

  @override
  State<CustomersDetailScreen> createState() => _CustomersDetailScreenState();
}

class _CustomersDetailScreenState extends State<CustomersDetailScreen> {
  String customer = "";
  String driver = "";
  String comments = "";
  List<String> drivers = [];
  bool isEditing = false;
  bool isAddingDriver = false;
  bool isDeleting = false;
  Customers? newCustomer;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> prefs) {
          if (prefs.data?.getBool(TEXT_SHARED) ?? false) {
            return BlocProvider(
              create: (_) => sl<CustomersCubit>(),
              child: BlocBuilder<CustomersCubit, CustomersState>(
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

  Widget stateManagement(BuildContext context, CustomersState state) {
    if (state is CustomersInitial) {
      return body(context);
    } else if (state is CustomersLoading) {
      return const CustomProgress();
    } else if (state is CustomersLoaded) {
      return CustomAlert(
          title: isDeleting
              ? "Cliente eliminado con éxito"
              : "Cliente actualizado con éxito",
          description: isDeleting
              ? "¡El cliente ${widget.customer.customer.toUpperCase()} se eliminó exitosamente!"
              : customer.isEmpty
                  ? "¡El cliente ${widget.customer.customer.toUpperCase()} se actualizó exitosamente!"
                  : "¡El cliente ${customer.toUpperCase()} se actualizó exitosamente!",
          isShowingError: false,
          onPressed: () => Navigator.of(context).pop());
    } else if (state is CustomersError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () =>
              isDeleting ? deleteCustomers(context) : updateCustomers(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () =>
              isDeleting ? deleteCustomers(context) : updateCustomers(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Info del cliente",
        automaticallyImplyLeading: true,
        onPressed: () {
          setState(() {
            isDeleting = true;
            showAlertDialog(
                context,
                "¿Confirmás la eliminación de ${widget.customer.customer.toUpperCase()}?",
                "Si confirmás la acción no se puede volver atrás (los contratos y los autos asignados al cliente seguirán estando)...",
                "ELIMINAR",
                null);
          });
        },
      ),
      floatingActionButton: floatingButtonWidget(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customerWidget(context),
              const SizedBox(
                height: 30,
              ),
              driversWidget(context),
              newDriverWidget(context),
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
    );
  }

  Widget customerWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          CustomTextField(
            title: "Nombre del cliente",
            hint: customer.isEmpty ? widget.customer.customer : customer,
            icon: Icons.people_rounded,
            onChanged: (value) {
              setState(() {
                customer = value;
              });
            },
          ),
        ],
        if (!isEditing) ...[
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
                "Nombre del cliente",
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
            text: customer.isEmpty ? widget.customer.customer : customer,
            isSelected: false,
          ),
        ],
      ],
    );
  }

  Widget driversWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing) ...[
          Text(
            "Conductores",
            style: GoogleFonts.roboto(
                fontWeight: WEIGHT_TEXT_ONE,
                fontSize: SIZE_TEXT_TWO,
                color: COLOR_BLACK_LIGHT),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (!isEditing) ...[
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
                "Conductores",
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
        ],
        const SizedBox(height: 10),
        Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: drivers.isEmpty
                      ? widget.customer.drivers.length
                      : drivers.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: 15,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Row(
                        children: [
                          if (isEditing) ...[
                            CustomElevatedButton(
                              text: "Nuevo conductor",
                              isSelected: isAddingDriver,
                              icon: Icons.add_rounded,
                              onPressed: (() {
                                setState(() {
                                  isAddingDriver = !isAddingDriver;
                                });
                              }),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            CustomElevatedButton(
                              text: drivers.isEmpty
                                  ? widget.customer.drivers[index]
                                  : drivers[index],
                              isSelected: false,
                              icon: Icons.delete_forever_rounded,
                              onPressed: (() {
                                setState(() {
                                  if ((drivers.isEmpty &&
                                          widget.customer.drivers.length > 1) ||
                                      (drivers.isNotEmpty &&
                                          drivers.length > 1)) {
                                    drivers = drivers.isEmpty
                                        ? widget.customer.drivers
                                            .where((element) =>
                                                element !=
                                                widget.customer.drivers[index])
                                            .toList()
                                        : drivers
                                            .where((element) =>
                                                element != drivers[index])
                                            .toList();
                                  }
                                });
                              }),
                            ),
                          ],
                          if (!isEditing) ...[
                            CustomElevatedButton(
                              text: drivers.isEmpty
                                  ? widget.customer.drivers[index]
                                  : drivers[index],
                              isSelected: true,
                            ),
                          ],
                        ],
                      );
                    }
                    return Row(
                      children: [
                        if (isEditing) ...[
                          CustomElevatedButton(
                            text: drivers.isEmpty
                                ? widget.customer.drivers[index]
                                : drivers[index],
                            isSelected: false,
                            icon: Icons.delete_forever_rounded,
                            onPressed: (() {
                              setState(() {
                                if ((drivers.isEmpty &&
                                        widget.customer.drivers.length > 1) ||
                                    (drivers.isNotEmpty &&
                                        drivers.length > 1)) {
                                  drivers = drivers.isEmpty
                                      ? widget.customer.drivers
                                          .where((element) =>
                                              element !=
                                              widget.customer.drivers[index])
                                          .toList()
                                      : drivers
                                          .where((element) =>
                                              element != drivers[index])
                                          .toList();
                                }
                              });
                            }),
                          ),
                        ],
                        if (!isEditing) ...[
                          CustomElevatedButton(
                            text: drivers.isEmpty
                                ? widget.customer.drivers[index]
                                : drivers[index],
                            isSelected: true,
                          ),
                        ],
                      ],
                    );
                  }),
            )),
      ],
    );
  }

  Widget newDriverWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAddingDriver) ...[
          const SizedBox(
            height: 30,
          ),
          CustomTextField(
            title: "Nombre del conductor",
            hint: "Ingresá el conductor",
            icon: Icons.sports_motorsports_rounded,
            onChanged: (value) {
              setState(() {
                driver = value;
              });
            },
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
            hint: comments.isEmpty
                ? widget.customer.comments == EMPTY
                    ? NO_COMMENTS
                    : widget.customer.comments
                : comments,
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
                ? widget.customer.comments == EMPTY
                    ? NO_COMMENTS
                    : widget.customer.comments
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
            customer = customer.isEmpty ? widget.customer.customer : customer;
            comments = comments.isEmpty ? widget.customer.comments : comments;
            drivers = drivers.isEmpty ? widget.customer.drivers : drivers;
            if (driver.isNotEmpty) {
              drivers = [...drivers, driver];
            }
            drivers.sort((a, b) => a.compareTo(b));
            isEditing = false;
            isAddingDriver = false;
            driver = "";

            newCustomer = Customers(
                comments: comments,
                customer: customer,
                drivers: drivers,
                id: widget.customer.id,
                isDeleted: false);
            updateCustomers(context);
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

  showAlertDialog(BuildContext context, String title, String content,
      String confirm, String? driver) {
    Widget cancelButton = TextButton(
      child: const Text(TEXT_CANCEL),
      onPressed: () {
        setState(() {
          isDeleting = false;
        });
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(confirm),
      onPressed: () {
        setState(() {
          deleteCustomers(context);
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

  Future<void> updateCustomers(BuildContext context) async {
    BlocProvider.of<CustomersCubit>(context).createCustomers(
        customers: newCustomer ??
            Customers(
                comments: comments,
                customer: customer,
                drivers: drivers,
                id: widget.customer.id,
                isDeleted: false));
  }

  Future<void> deleteCustomers(BuildContext context) async {
    BlocProvider.of<CustomersCubit>(context)
        .deleteCustomers(id: widget.customer.id);
  }
}
