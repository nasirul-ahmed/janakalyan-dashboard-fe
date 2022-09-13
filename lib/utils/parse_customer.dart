import 'dart:convert';
import 'package:janakalyan_admin/models/customer_model.dart';

List<Customer> parseCustomer(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
}