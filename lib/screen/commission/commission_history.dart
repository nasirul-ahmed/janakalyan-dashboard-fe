import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/comission.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CommissionHistory extends StatelessWidget {
  final int? collectorId;
  CommissionHistory({Key? key, this.collectorId}) : super(key: key);
// /api/admin/get-loan-repayment/5"

  Future<List<Commission>> getCommissionHistory() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/commission-history');
    //final url = Uri.parse("uri");
    var body = jsonEncode(<String, dynamic>{"collectorId": collectorId});
    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
        //print(parsed);
        List<Commission> list = parsed
            .map<Commission>((json) => Commission.fromJson(json))
            .toList();

        return list;
      }
      return List<Commission>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commission History")),
      body: Container(
        child: FutureBuilder<List<Commission>>(
          future: getCommissionHistory(),
          builder: (_, snap) {
            if (snap.hasError) {
              return const Text("error");
            } else if (snap.hasData) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [renderDatatable(snap.data)],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView renderDatatable(List<Commission>? list) {
    TextStyle style = const TextStyle(color: Colors.black, fontSize: 16);
    TextStyle style1 = const TextStyle(color: Colors.black, fontSize: 16);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: [
              DataColumn(label: Text('ID', style: style1)),
              DataColumn(label: Text('Date', style: style1)),
              DataColumn(label: Text('Amount', style: style1)),
              DataColumn(label: Text('Months', style: style1)),
            ],
            rows: list!
                .map(
                  (Commission document) => DataRow(cells: [
                    DataCell(Text(
                      "${document.id}",
                      style: style,
                    )),
                    DataCell(Text(
                      formatDate(document.createdAt),
                      style: style,
                    )),
                    DataCell(Text(
                      "${document.commissionPaid}",
                      style: style,
                    )),
                    DataCell(Text(
                      formatDate(document.payMonth),
                      style: style,
                    )),
                  ]),
                )
                .toList()),
      ),
    );
  }
}
