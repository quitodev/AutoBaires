import 'package:equatable/equatable.dart';

class Customers extends Equatable {
  const Customers({
    required this.comments,
    required this.customer,
    required this.drivers,
    required this.id,
    required this.isDeleted,
  });

  final String comments;
  final String customer;
  final List<String> drivers;
  final String id;
  final bool isDeleted;

  @override
  List<Object?> get props => [
        comments,
        customer,
        drivers,
        id,
        isDeleted,
      ];
}
