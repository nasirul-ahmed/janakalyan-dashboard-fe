import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/expense_model.dart';
import 'package:janakalyan_admin/models/salary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalaryServices {
  Future createSalary(
      int amount, String emplyeeName, String createdAt, int empNo) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/create/salary');

    //salaryAmount, employeeName, createdAt, empNo
    var jsonBody = jsonEncode(<String, dynamic>{
      "salaryAmount": amount,
      "emplyeeName": emplyeeName,
      "createdAt": createdAt,
      "empNo": empNo
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

  Future<List<Salary>> getAllSalaries() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-salaries');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        //print(res.body);
        List<Salary> list =
            parsed.map<Salary>((json) => Salary.fromJson(json)).toList();
        return list;
      }
      return List<Salary>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }
}
