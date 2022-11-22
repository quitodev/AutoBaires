import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/contracts/contracts.dart';
import 'package:autobaires/injection_container.dart';
import 'package:autobaires/presentation/cubit/contracts/contracts_cubit.dart';
import 'package:autobaires/presentation/views/home/contracts/widgets/card_contracts.dart';
import 'package:autobaires/presentation/views/widgets/custom_alert.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_elevated_button.dart';
import 'package:autobaires/presentation/views/widgets/custom_progress.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_CONTRACTS_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const ContractsScreen(),
    );
  }

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  String customerSelected = "";
  List<Contracts> contractsFiltered = [];
  List<String> customers = [];

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
      getContracts(context);
      return const CustomProgress();
    } else if (state is ContractsLoading) {
      return const CustomProgress();
    } else if (state is ContractsLoaded) {
      final contracts = state.list!;
      contractsFiltered = customerSelected.isEmpty
          ? contracts
          : contracts
              .where((contract) => contract.customer == customerSelected)
              .toList();
      for (var contract in contracts) {
        if (!customers.contains(contract.customer)) {
          customers.add(contract.customer);
        }
      }
      return body(context, contracts);
    } else if (state is ContractsError) {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getContracts(context),
          onCancel: () => Navigator.of(context).pop());
    } else {
      return CustomAlert(
          title: ERROR_TITLE,
          description: ERROR_DESCRIPTION,
          isShowingError: true,
          onPressed: () => getContracts(context),
          onCancel: () => Navigator.of(context).pop());
    }
  }

  Widget body(BuildContext context, List<Contracts> contracts) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Contratos",
          automaticallyImplyLeading: true,
          isSearching: true,
          onPressed: () {
            Navigator.pushNamed(context, ROUTE_CONTRACTS_SEARCH_SCREEN,
                    arguments: contractsFiltered)
                .then((_) => getContracts(context));
          },
        ),
        floatingActionButton: floatingButtonWidget(context),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buttonsWidget(context, contracts),
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

  Widget buttonsWidget(BuildContext context, List<Contracts> contracts) {
    return Container(
        height: 35,
        alignment: Alignment.centerLeft,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: customers.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 15,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    if (index == 0) ...[
                      CustomElevatedButton(
                        text: "Todos",
                        isSelected: customerSelected == "",
                        onPressed: (() {
                          setState(() {
                            customerSelected = "";
                            contractsFiltered = contracts;
                          });
                        }),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                    CustomElevatedButton(
                      text: customers[index],
                      isSelected: customers[index] == customerSelected,
                      onPressed: (() {
                        setState(() {
                          customerSelected = customers[index];
                          contractsFiltered = contracts
                              .where((contract) =>
                                  contract.customer == customerSelected)
                              .toList();
                        });
                      }),
                    ),
                  ],
                );
              }),
        ));
  }

  Widget titleWidget(BuildContext context) {
    return Text(
      customerSelected.isEmpty
          ? "Tenés ${contractsFiltered.where((contract) => !contract.isFinished).toList().length == 1 ? '1 contrato vigente' : '${contractsFiltered.where((contract) => !contract.isFinished).toList().length} contratos vigentes'}"
          : "Tenés ${contractsFiltered.where((contract) => !contract.isFinished).toList().length == 1 ? '1 contrato vigente de' : '${contractsFiltered.where((contract) => !contract.isFinished).toList().length} contratos vigentes de'} $customerSelected",
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
            onRefresh: () => getContracts(context),
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: ListView.builder(
                  itemCount: contractsFiltered.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                                  context, ROUTE_CONTRACTS_DETAIL_SCREEN,
                                  arguments: contractsFiltered[index])
                              .then((_) => getContracts(context));
                        },
                        child:
                            CardContracts(contract: contractsFiltered[index]));
                  }),
            )));
  }

  Widget floatingButtonWidget(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 12,
      backgroundColor: COLOR_MAGENTA,
      onPressed: () {
        Navigator.pushNamed(context, ROUTE_CONTRACTS_NEW_SCREEN,
                arguments: contractsFiltered.first)
            .then((_) => getContracts(context));
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

  Future<void> getContracts(BuildContext context) async {
    BlocProvider.of<ContractsCubit>(context).getContracts();
  }
}
