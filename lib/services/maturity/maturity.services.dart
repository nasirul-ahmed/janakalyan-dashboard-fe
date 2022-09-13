import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaturityServices {
  Future<List<Maturity>> getPendingMaturity() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/all-maturity-list');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<Maturity> list =
            parsed.map<Maturity>((json) => Maturity.fromJson(json)).toList();
        return list;
      }
      return List<Maturity>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Maturity>> getProcessMaturity() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/processed-maturity-list');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<Maturity> list =
            parsed.map<Maturity>((json) => Maturity.fromJson(json)).toList();
        return list;
      }
      return List<Maturity>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> processMaturity(
    int id,
    int maturityValue,
    String processDate,
    int maturityAmount,
    num maturityInterest,
    num preMaturityCharge,
  ) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/process-maturity');

    var body = jsonEncode(<String, dynamic>{
      "id": id,
      "maturityValue": maturityValue,
      "processDate": processDate,
      "maturityAmount": maturityAmount,
      "maturityInterest": maturityInterest,
      "preMaturityCharge": preMaturityCharge,
      "loss": 0,
    });
    // print(id)

    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> matureSuccessfully(Maturity maturity) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/success-maturity');

    var body = jsonEncode(<String, dynamic>{
      "id": maturity.id,
      "totalAmount": maturity.totalAmount,
      "closingDate": DateTime.now().toString(),
      "collectorId": maturity.collectorId,
      "createdAt": DateTime.now().toString(),
      "accountNumber": maturity.accountNumber,
      "maturityInterest": maturity.maturityInterest,
      "prematurityCharge": maturity.preMaturityCharge,
      "isPrematurity": maturity.isPreMaturity,
    });

    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> rejectMaturity(int id, int ac) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/reject-maturity');

    var body = jsonEncode(<String, dynamic>{
      "id": id,
      "accountNumber": ac,
    });

    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
