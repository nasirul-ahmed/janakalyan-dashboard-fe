import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/deposit_history_model.dart';
import 'package:janakalyan_admin/models/loan_deposit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepositsServices {
  Future<List<DepositHistoryModel>> pendings() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/pending-deposits');
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<DepositHistoryModel>(
                (json) => DepositHistoryModel.fromJson(json))
            .toList();
      }
      return List<DepositHistoryModel>.empty();
    } catch (e) {
      throw e;
    }
  }

  Future<List<LoanDepositModel>> pendingsLoanDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/pending/loan-deposit');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<LoanDepositModel>((json) => LoanDepositModel.fromJson(json))
            .toList();
      }
      return List<LoanDepositModel>.empty();
    } catch (e) {
      throw e;
    }
  }

  Future<List<DepositHistoryModel>> success() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/success-deposits');
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<DepositHistoryModel>(
                (json) => DepositHistoryModel.fromJson(json))
            .toList();
      }
      return List<DepositHistoryModel>.empty();
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> rejectDeposit(
      int amount, int collectorId, int id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/reject-deposit');

    try {
      var body = jsonEncode(<String, dynamic>{
        "amount": amount,
        "collectorId": collectorId,
        "id": id,
      });

      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return res;
      }
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> rejectLoanDeposit(
      int amount, int collectorId, int id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/reject-loan-deposit');

    try {
      var body = jsonEncode(<String, dynamic>{
        "amount": amount,
        "collectorId": collectorId,
        "id": id,
      });

      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return res;
      }
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> acceptDeposits(
      int amount, int collectorId, int id, String createdAt) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/accept-deposit');
    //collectorId, amount, createdAt, docId
    try {
      var body = jsonEncode(<String, dynamic>{
        "amount": amount,
        "collectorId": collectorId,
        "docId": id,
        "createdAt": createdAt,
      });

      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return res;
      }
      return res;
    } catch (e) {
      throw e;
    }
  }

  Future<http.Response> acceptLoanDeposits(int id) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/accept-loan-deposits');

    try {
      var body = jsonEncode(<String, dynamic>{
        "docId": id,
      });

      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return res;
      }
      return res;
    } catch (e) {
      throw e;
    }
  }
}
