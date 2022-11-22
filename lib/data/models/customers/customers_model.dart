// ignore_for_file: overridden_fields, annotate_overrides, unnecessary_null_comparison

import 'package:autobaires/domain/entities/customers/customers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomersModel extends Customers {
  const CustomersModel({
    required this.comments,
    required this.customer,
    required this.drivers,
    required this.id,
    required this.isDeleted,
  }) : super(
          comments: comments,
          customer: customer,
          drivers: drivers,
          id: id,
          isDeleted: isDeleted,
        );

  final String comments;
  final String customer;
  final List<String> drivers;
  final String id;
  final bool isDeleted;

  factory CustomersModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CustomersModel(
      comments: data?['comments'],
      customer: data?['customer'],
      drivers: List.from(data?['drivers']),
      id: data?['id'],
      isDeleted: data?['isDeleted'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (comments != null) "comments": comments,
      if (customer != null) "customer": customer,
      if (drivers != null) "drivers": drivers,
      if (id != null) "id": id,
      if (isDeleted != null) "isDeleted": isDeleted,
    };
  }
}
