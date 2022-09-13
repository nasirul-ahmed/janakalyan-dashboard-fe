import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanApplicationServices {
  String processDate;
  int collectorId;
  int amount;

  LoanApplicationServices(this.amount, this.collectorId, this.processDate);
  Future<void> processApplication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/process-application');
    var jsonBody = jsonEncode(<String, dynamic>{
      "id": collectorId,
      "amount": amount,
      "processDate": processDate
    });
    try {
      var res = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print("success");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future processAndCreateLoan() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/create-loan-account');
    var jsonBody = jsonEncode(<String, dynamic>{
      "id": collectorId,
      "amount": amount,
      "processDate": processDate
    });
    try {
      var res = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print("success");
      } else {
        return List<Customer>.empty();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
