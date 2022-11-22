import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/contracts/contracts.dart';
import 'package:autobaires/presentation/views/home/contracts/widgets/card_contracts.dart';
import 'package:autobaires/presentation/views/widgets/custom_app_bar.dart';
import 'package:autobaires/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:autobaires/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ContractsSearchScreen extends StatefulWidget {
  const ContractsSearchScreen({Key? key, required this.contracts})
      : super(key: key);

  final List<Contracts> contracts;

  static const String routeName = ROUTE_CONTRACTS_SEARCH_SCREEN;

  static Route route({required List<Contracts> contracts}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ContractsSearchScreen(contracts: contracts),
    );
  }

  @override
  State<ContractsSearchScreen> createState() => _ContractsSearchScreenState();
}

class _ContractsSearchScreenState extends State<ContractsSearchScreen> {
  List<Contracts> contractsFiltered = [];

  @override
  void initState() {
    contractsFiltered = widget.contracts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Buscar contratos",
          automaticallyImplyLeading: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchWidget(context),
              const SizedBox(
                height: 20,
              ),
              listWidget(context),
            ],
          ),
        ));
  }

  Widget searchWidget(BuildContext context) {
    return CustomTextField(
      title: "Buscá el contrato por conductor...",
      hint: "Ingresá algún conductor",
      icon: Icons.search_rounded,
      onChanged: (value) {
        setState(() {
          contractsFiltered = widget.contracts
              .where((contract) =>
                  contract.driver.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  Widget listWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 230,
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: ListView.builder(
              itemCount: contractsFiltered.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, ROUTE_CONTRACTS_DETAIL_SCREEN,
                          arguments: contractsFiltered[index]);
                    },
                    child: CardContracts(contract: contractsFiltered[index]));
              }),
        ));
  }
}
