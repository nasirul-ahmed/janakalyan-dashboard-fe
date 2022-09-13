import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/cashbook.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashbookServices {
  Future<List<Cashbook>> getAllCashbook() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/all-cashbook');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<Cashbook> list =
            parsed.map<Cashbook>((json) => Cashbook.fromJson(json)).toList();
        return list;
      }
      return List<Cashbook>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<List<Cashbook>> getCashbook() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/cashbook');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<Cashbook> list =
            parsed.map<Cashbook>((json) => Cashbook.fromJson(json)).toList();
        return list;
      }
      return List<Cashbook>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Cashbook>> getCashbookByDate(String date) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/cashbook-by-dates');

    var body = jsonEncode({"date": date});

    print(date);

    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);

        List<Cashbook> list =
            parsed.map<Cashbook>((json) => Cashbook.fromJson(json)).toList();
        return list;
      }
      return List<Cashbook>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }
}
