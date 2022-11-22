import 'package:autobaires/data/datasources/customers/customers_remote_datasource.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/domain/repositories/customers/customers_repository.dart';

class CustomersRepositoryImpl extends CustomersRepository {
  final CustomersRemoteDataSource remoteDataSource;

  CustomersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Customers>> getCustomers() async {
    return remoteDataSource.getCustomers();
  }

  @override
  Future<void> createCustomers(Customers customer) async {
    return remoteDataSource.createCustomers(customer);
  }

  @override
  Future<void> updateCustomers(Customers customer) async {
    return remoteDataSource.updateCustomers(customer);
  }

  @override
  Future<void> deleteCustomers(String id) async {
    return remoteDataSource.deleteCustomers(id);
  }
}
