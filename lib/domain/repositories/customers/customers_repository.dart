import 'package:autobaires/domain/entities/customers/customers.dart';

abstract class CustomersRepository {
  Future<List<Customers>> getCustomers();
  Future<void> createCustomers(Customers customer);
  Future<void> updateCustomers(Customers customer);
  Future<void> deleteCustomers(String id);
}
