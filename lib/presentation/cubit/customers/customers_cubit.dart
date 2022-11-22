import 'dart:io';

import 'package:autobaires/core/constants.dart';
import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:autobaires/domain/usecases/customers/create_customers_usecase.dart';
import 'package:autobaires/domain/usecases/customers/delete_customers_usecase.dart';
import 'package:autobaires/domain/usecases/customers/get_customers_usecase.dart';
import 'package:autobaires/domain/usecases/customers/update_customers_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  final CustomersGetCustomers getCustomersUseCase;
  final CustomersCreateCustomers createCustomersUseCase;
  final CustomersUpdateCustomers updateCustomersUseCase;
  final CustomersDeleteCustomers deleteCustomersUseCase;

  CustomersCubit({
    required this.getCustomersUseCase,
    required this.createCustomersUseCase,
    required this.updateCustomersUseCase,
    required this.deleteCustomersUseCase,
  }) : super(CustomersInitial());

  Future<void> getCustomers() async {
    //emit(CustomersLoading());
    try {
      final customers = await getCustomersUseCase.call();
      customers.isEmpty
          ? emit(const CustomersError(FAILURE))
          : emit(CustomersLoaded(customers));
    } on SocketException catch (_) {
      emit(const CustomersError(FAILURE));
    } catch (_) {
      emit(const CustomersError(FAILURE));
    }
  }

  Future<void> createCustomers({required Customers customers}) async {
    emit(CustomersLoading());
    try {
      await createCustomersUseCase.call(customers);
      emit(const CustomersLoaded(null));
    } on SocketException catch (_) {
      emit(const CustomersError(FAILURE));
    } catch (_) {
      emit(const CustomersError(FAILURE));
    }
  }

  Future<void> updateCustomers({required Customers customers}) async {
    emit(CustomersLoading());
    try {
      await updateCustomersUseCase.call(customers);
      emit(const CustomersLoaded(null));
    } on SocketException catch (_) {
      emit(const CustomersError(FAILURE));
    } catch (_) {
      emit(const CustomersError(FAILURE));
    }
  }

  Future<void> deleteCustomers({required String id}) async {
    emit(CustomersLoading());
    try {
      await deleteCustomersUseCase.call(id);
      emit(const CustomersLoaded(null));
    } on SocketException catch (_) {
      emit(const CustomersError(FAILURE));
    } catch (_) {
      emit(const CustomersError(FAILURE));
    }
  }
}
