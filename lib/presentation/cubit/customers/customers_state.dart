part of 'customers_cubit.dart';

abstract class CustomersState extends Equatable {
  const CustomersState();
}

class CustomersInitial extends CustomersState {
  @override
  List<Object> get props => [];
}

class CustomersLoading extends CustomersState {
  @override
  List<Object> get props => [];
}

class CustomersLoaded extends CustomersState {
  final List<Customers>? list;

  const CustomersLoaded(this.list);

  @override
  List<Object> get props => [list!];
}

class CustomersError extends CustomersState {
  final String message;

  const CustomersError(this.message);

  @override
  List<Object> get props => [message];
}
