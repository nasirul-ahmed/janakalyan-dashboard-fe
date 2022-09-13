import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loss_profit.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LossAndProfitServices {
  Future<List<LossAndProfitModel>> getAllLossAndProfit() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/all-loss-profit');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<LossAndProfitModel> list = parsed
            .map<LossAndProfitModel>(
                (json) => LossAndProfitModel.fromJson(json))
            .toList();
        return list;
      }
      return List<LossAndProfitModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LossAndProfitModel>> getLossAndProfit() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-loss-profit');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<LossAndProfitModel> list = parsed
            .map<LossAndProfitModel>(
                (json) => LossAndProfitModel.fromJson(json))
            .toList();
        return list;
      }
      return List<LossAndProfitModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LossAndProfitModel>> getLossAndProfitByDate(String date) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-loss-profit/$date');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        List<LossAndProfitModel> list = parsed
            .map<LossAndProfitModel>(
                (json) => LossAndProfitModel.fromJson(json))
            .toList();
        return list;
      }
      return List<LossAndProfitModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }
}
