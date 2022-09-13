import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagementServices {
  Future expenseRelatedAmounts() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/expense-related-amount');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed[0];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future loanRelatedAmounts() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/loan-related-amount');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);
        return parsed[0];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future maturityRelatedAmounts() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/maturity-related-amount');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);
        return parsed[0];
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
