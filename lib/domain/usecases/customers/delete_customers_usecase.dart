import 'package:autobaires/domain/repositories/customers/customers_repository.dart';

class CustomersDeleteCustomers {
  final CustomersRepository repository;

  CustomersDeleteCustomers({required this.repository});

  Future<void> call(String id) async {
    return repository.deleteCustomers(id);
  }
}
