import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommissionServices {
  Future payCommission(
      int commission, String selectedDate, int collector) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/pay-commission');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": collector,
      "commissionPaid": commission,
      "createdAt": DateTime.now().toString(),
      "paidMonth": selectedDate.toString()
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> getCommission(String selectedDate, int collector) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/monthly-commission');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": collector,
      "createdAt": selectedDate.toString(),
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        num cm = parsed[0]["commission"] ?? 0;
        return cm;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> thisMonthsDeposits(String date, int collector) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("$janaklyan/api/admin/monthly-deposits");
    //final url = Uri.parse("uri");
    final date = DateTime.now();
    var body = jsonEncode(<String, dynamic>{
      "collectorId": collector,
      "createdAt": date.toString().split(' ')[0]
    });
    try {
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          },
          body: body);
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed[0]["deposits"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }
}
