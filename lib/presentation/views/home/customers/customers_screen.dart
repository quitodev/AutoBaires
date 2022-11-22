import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/customers/customers_cubit.dart';
import 'package:autobaires/presentation/views/home/customers/widgets/card_customers.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_CUSTOMERS_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const CustomersScreen(),
    );
  }

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
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
      getCustomers(context);
      return const CustomProgress();
    } else if (state is CustomersLoading) {
      return const CustomProgress();
    } else if (state is CustomersLoaded) {
      return body(
          context, state.list!.where((element) => !element.isDeleted).toList());
    } else if (state is CustomersError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getCustomers(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getCustomers(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context, List<Customers> customers) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Clientes y Conductores",
          automaticallyImplyLeading: true,
        ),
        floatingActionButton: floatingButtonWidget(context),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget(context, customers),
              const SizedBox(
                height: 20,
              ),
              listWidget(context, customers),
            ],
          ),
        ));
  }

  Widget titleWidget(BuildContext context, List<Customers> customers) {
    return Text(
      customers.length == 1
          ? "Tenés 1 cliente"
          : "Tenés ${customers.length} clientes",
      style: GoogleFonts.roboto(
          fontWeight: WEIGHT_TEXT_ONE,
          fontSize: SIZE_TEXT_ONE,
          color: COLOR_BLACK),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget listWidget(BuildContext context, List<Customers> customers) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 175,
      child: RefreshIndicator(
          onRefresh: () => getCustomers(context),
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                                context, ROUTE_CUSTOMERS_DETAIL_SCREEN,
                                arguments: customers[index])
                            .then((_) => getCustomers(context));
                      },
                      child: CardCustomers(customer: customers[index]));
                }),
          )),
    );
  }

  Widget floatingButtonWidget(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 12,
      backgroundColor: COLOR_MAGENTA,
      onPressed: () {
        Navigator.pushNamed(context, ROUTE_CUSTOMERS_NEW_SCREEN)
            .then((_) => getCustomers(context));
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

  Future<void> getCustomers(BuildContext context) async {
    BlocProvider.of<CustomersCubit>(context).getCustomers();
  }
}
