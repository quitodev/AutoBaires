import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/domain/repositories/customers/customers_repository.dart';

class CustomersUpdateCustomers {
  final CustomersRepository repository;

  CustomersUpdateCustomers({required this.repository});

  Future<void> call(Customers customer) async {
    return repository.updateCustomers(customer);
  }
}
