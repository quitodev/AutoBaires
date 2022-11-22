import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/customers/customers_cubit.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_message.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersNewScreen extends StatefulWidget {
  const CustomersNewScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_CUSTOMERS_NEW_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const CustomersNewScreen(),
    );
  }

  @override
  State<CustomersNewScreen> createState() => _CustomersNewScreenState();
}

class _CustomersNewScreenState extends State<CustomersNewScreen> {
  bool isShowingAlert = false;
  String customer = "";
  String driver = "";
  String comments = "";
  List<String> drivers = [];
  late Customers newCustomer;

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
          title: "Cliente agregado con éxito",
          description:
              "¡El cliente ${customer.toUpperCase()} se dio de alta exitosamente!",
          isShowingError: false,
          onPressed: () => Navigator.of(context).pop());
    } else if (state is CustomersError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => createCustomers(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => createCustomers(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          appBar: CustomAppBar(
            title: "Nuevo cliente",
            automaticallyImplyLeading: true,
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
                  driverWidget(context),
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
        ),
        if (isShowingAlert) ...[
          const Spacer(),
          CustomMessage(
              isShowingAlert: isShowingAlert,
              description: "Ups! Revisá que todos los campos estén completos!"),
        ],
      ],
    );
  }

  Widget customerWidget(BuildContext context) {
    return CustomTextField(
      title: "Nombre del cliente",
      hint: "Ingresá el cliente",
      icon: Icons.people_rounded,
      onChanged: (value) {
        setState(() {
          customer = value;
        });
      },
    );
  }

  Widget driverWidget(BuildContext context) {
    return CustomTextField(
      title: "Nombre del conductor",
      hint: "Ingresá el conductor",
      icon: Icons.sports_motorsports_rounded,
      onChanged: (value) {
        setState(() {
          driver = value;
        });
      },
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
            if (customer.isEmpty || driver.isEmpty) {
              isShowingAlert = true;
              Future.delayed(const Duration(milliseconds: 3000), () {
                setState(() {
                  isShowingAlert = false;
                });
              });
            } else {
              drivers.add(driver);
              drivers.sort((a, b) => a.compareTo(b));
              newCustomer = Customers(
                  comments: comments.isEmpty ? EMPTY : comments,
                  customer: customer,
                  drivers: drivers,
                  id: UniqueKey().toString(),
                  isDeleted: false);
              createCustomers(context);
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

  void createCustomers(BuildContext context) async {
    BlocProvider.of<CustomersCubit>(context)
        .createCustomers(customers: newCustomer);
  }
}
