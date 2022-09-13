import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HoldAccount {
  
  Future<List<Customer>> getHoldAccounts() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/hold-accounts');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        var x = parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
        print(parsed[0]);
        return x;
      } else {
        return List<Customer>.empty();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> holdaccount(accountNo) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/hold/$accountNo');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        log(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> unhold(accountNo) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/unhold/$accountNo');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        log(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
