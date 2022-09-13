import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/expense_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseServices {
  Future addExpense(int amount, String particulars, String createdAt, int flag,
      int emp_no) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/create-expense');
    //amount, particulars = "", createdAt, flag = 0
    var jsonBody = jsonEncode(<String, dynamic>{
      "amount": amount,
      "particulars": particulars,
      "createdAt": createdAt,
      "flag": flag,
      "emp_no": 0
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        //print(res.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<ExpenseModel>> getExpenses() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-expense');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        
        List<ExpenseModel> list = parsed
            .map<ExpenseModel>((json) => ExpenseModel.fromJson(json))
            .toList();
        return list;
      }
      return List<ExpenseModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ExpenseModel>> getAllExpenses() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/all-expense');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        
        List<ExpenseModel> list = parsed
            .map<ExpenseModel>((json) => ExpenseModel.fromJson(json))
            .toList();
        return list;
      }
      return List<ExpenseModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ExpenseModel>> getExpensesByDate(String date) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/expenses/$date');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
       
        List<ExpenseModel> list = parsed
            .map<ExpenseModel>((json) => ExpenseModel.fromJson(json))
            .toList();
        return list;
      }
      return List<ExpenseModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }
}
