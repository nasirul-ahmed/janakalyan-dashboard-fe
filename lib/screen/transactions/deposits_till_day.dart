import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/deposit_history_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectorTransactions extends StatelessWidget {
  final int? collectorId;
  const CollectorTransactions(this.collectorId);

  Future<List<DepositHistoryModel>> depositHis() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/deposit/tnx/$collectorId');
    //final url = Uri.parse("uri");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collector Deposits"),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.8,
          child: FutureBuilder<List<DepositHistoryModel>>(
            future: depositHis(),
            builder: (_, snap) {
              if (snap.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              } else if (snap.hasData) {
                return renderDatatable(snap.data);
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

SingleChildScrollView renderDatatable(List<DepositHistoryModel>? list) {
  TextStyle style = const TextStyle(color: Colors.black, fontSize: 14);
  TextStyle style1 = const TextStyle(color: Colors.black, fontSize: 16);
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          dataRowHeight: 28.0,
          columns: [
            DataColumn(label: Text('ID', style: style1)),
            DataColumn(label: Text('Date', style: style1)),
            DataColumn(label: Text('Amount', style: style1)),
            DataColumn(label: Text('Commission', style: style1)),
          ],
          rows: list!
              .map(
                (DepositHistoryModel document) => DataRow(cells: [
                  DataCell(Text(
                    '${document.id}',
                    style: style,
                  )),
                  DataCell(Text(
                    formatDate(document.createdAt),
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.amount}',
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.commission}',
                    style: style,
                  )),
                ]),
              )
              .toList()),
    ),
  );
}
