import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/screen/account_details/account_details.dart';
import 'package:janakalyan_admin/utils/isNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerServices {
  Future<List<Customer>> getAllCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-customer');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();

        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Customer>> getOnlyHundredCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-customer-hundred');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();

        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Customer>> getCustomerByAc(String query) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = isNumeric(query)
        ? Uri.parse('$janaklyan/api/admin/get-customer/$query')
        : Uri.parse('$janaklyan/api/admin/get-customer-by-name/$query');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Customer>> getCustomerByCollector(int collector) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/cust-by-collector/$collector');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      rethrow;
    }
  }

  Future<num> countCust() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/count');
    //final url =Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        return parsed[0]["count"];
      }
      return 0;
    } catch (e) {
      rethrow;
    }
  }


  // under  maturity accounts
  Future<List<Customer>> getMaturityAccounts() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/processed-matured-customer');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      rethrow;
    }
  }
}
