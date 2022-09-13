import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayCollection {
  Future<num> todaysDepositCollectionById(
      int collectorId, DateTime selectedDate) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-collection/collector');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": collectorId,
      "date":
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day - 1}"
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        return parsed[0]["todayCollection"] ?? 0;
      }
      return 0;
    } catch (e) {
      throw e;
    }
  }

  Future<num> todaysDepositsC() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-collection');

    try {
      var res = await http.post(url,
          body:
              jsonEncode(<String, dynamic>{"date": DateTime.now().toString().split(" ")[0]}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);
        return parsed[0]["todayCollection"] ?? 0;
      }
      return 0;
    } catch (e) {
      throw e;
    }
  }

  Future<num> todaysLoanCollectionById(
      int collectorId, DateTime selectedDate) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-collection/collector');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": collectorId,
      "date":
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day - 1}"
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        return parsed[0]["todayCollection"] ?? 0;
      }
      return 0;
    } catch (e) {
      throw e;
    }
  }

  Future<num> todaysLoanC() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-loan-collection');

    try {
      var res = await http.post(url,
          body:
              jsonEncode(<String, dynamic>{"date": DateTime.now().toString().split(" ")[0]}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);
        return parsed[0]["todayLoanCollection"] ?? 0;
      }
      return 0;
    } catch (e) {
      throw e;
    }
  }
}
