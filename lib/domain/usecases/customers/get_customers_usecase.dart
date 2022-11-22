import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/domain/repositories/customers/customers_repository.dart';

class CustomersGetCustomers {
  final CustomersRepository repository;

  CustomersGetCustomers({required this.repository});

  Future<List<Customers>> call() async {
    return repository.getCustomers();
  }
}
