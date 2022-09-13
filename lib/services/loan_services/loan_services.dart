import 'dart:convert';

import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_application_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

class LoanServices {
  num pendings = 0;
  num approved = 0;

  num get getPendings {
    return pendings;
  }

  set setPendings(num count) {
    pendings = count;
  }

  num get getApproved {
    return approved;
  }

  set setApproved(num count) {
    approved = count;
  }
  Future<void> deleteApplication(int applicationId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse("$janaklyan/api/collector/delete-loan-application");

    var body = jsonEncode(<String, dynamic>{
      "collectorId": _prefs.getInt('collectorId'),
      "applicationId": applicationId
    });

    try {
      var res = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}",
      });
      if (200 == res.statusCode) {
        // return compute(parseTransactions, res.body);
        final parsed = jsonDecode(res.body);
        print(parsed.toString());

      } else {
        print(res.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LoanApplicationModel>> pendingLoanApplication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/loan-application');
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<LoanApplicationModel> list = parsed
            .map<LoanApplicationModel>(
                (json) => LoanApplicationModel.fromJson(json))
            .toList();
        pendings = list.length;
        return list;
      }
      return List<LoanApplicationModel>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<LoanApplicationModel>> processLoanApplication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/approved-loan-application');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<LoanApplicationModel> list = parsed
            .map<LoanApplicationModel>(
                (json) => LoanApplicationModel.fromJson(json))
            .toList();
        approved = list.length;
        return list;
      }
      return List<LoanApplicationModel>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> countLoans() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/count-loans');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);

        setPendings = parsed[0][0]["pendings"];
        setApproved = parsed[1][0]["approved"];
//[[{pendings: 8}], [{approved: 0}]]

        //this.pendings =
        // List<num> l = [];
        // l.add(parsed[0][0]);
        // l.add(parsed[1][0]);
        // return l;

      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
