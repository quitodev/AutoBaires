import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/domain/repositories/customers/customers_repository.dart';

class CustomersCreateCustomers {
  final CustomersRepository repository;

  CustomersCreateCustomers({required this.repository});

  Future<void> call(Customers customer) async {
    return repository.createCustomers(customer);
  }
}
