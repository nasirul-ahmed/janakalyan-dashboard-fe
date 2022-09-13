import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/transaction_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectorDeposits extends StatefulWidget {
  final int? collectorId;
  const CollectorDeposits(this.collectorId);

  @override
  State<CollectorDeposits> createState() => _CollectorDepositsState();
}

class _CollectorDepositsState extends State<CollectorDeposits> {
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<num?> todayCollection() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-collection/collector');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": widget.collectorId,
      "date": "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"
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
        return parsed[0]["todayCollection"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<TransactionsModel>> getTransactions() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-trans-by-date');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collector": widget.collectorId,
      "date": "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
        print(res.body);
        return parsed
            .map<TransactionsModel>((json) => TransactionsModel.fromJson(json))
            .toList();
      }
      return List<TransactionsModel>.empty();
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Collector Deposits"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.blue,
                      width: 250,
                      height: 80,
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Select a date here", style: style),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              formatDate(selectedDate),
                              style: style,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<num?>(
                    future: todayCollection(),
                    builder: (_, snap) {
                      if (snap.hasError) {
                        return const Center(
                          child: Text("Error"),
                        );
                      } else if (snap.hasData) {
                        return Container(
                          color: Colors.blueGrey,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Center(
                            child: Text(
                              "Rs. ${snap.data}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: FutureBuilder<List<TransactionsModel>>(
                future: getTransactions(),
                builder: (_, snap) {
                  if (snap.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  } else if (snap.hasData) {
                    return ListView.builder(
                        itemCount: snap.data!.length,
                        itemBuilder: (_, id) {
                          var style = TextStyle(
                            fontSize: 15,
                          );
                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "A/c: ${snap.data![id].customer_account}",
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                  "Date : ${formatDate(snap.data![id].date)}"),
                              title: Text("TNX Id: ${snap.data![id].id}"),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Amount : ${snap.data![id].amount}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Total Amount : ${snap.data![id].totalCollection}",
                                    style: style,
                                  ),
                                ],
                              ),
                            ),
                          ));
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SingleChildScrollView renderDatatable(List<DepositHistoryModel>? list) {
//   TextStyle style = const TextStyle(color: Colors.black, fontSize: 14);
//   TextStyle style1 = const TextStyle(color: Colors.black, fontSize: 16);
//   return SingleChildScrollView(
//     scrollDirection: Axis.vertical,
//     child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//           dataRowHeight: 28.0,
//           columns: [
//             DataColumn(label: Text('ID', style: style1)),
//             DataColumn(label: Text('Date', style: style1)),
//             DataColumn(label: Text('Amount', style: style1)),
//             DataColumn(label: Text('Commission', style: style1)),
//           ],
//           rows: list!
//               .map((DepositHistoryModel document) => DataRow(cells: [
//                     DataCell(Text(
//                       '${document.id}',
//                       style: style,
//                     )),
//                     DataCell(Text(
//                       formatDate(document.createdAt),
//                       style: style,
//                     )),
//                     DataCell(Text(
//                       '${document.amount}',
//                       style: style,
//                     )),
//                     DataCell(Text(
//                       '${document.commission}',
//                       style: style,
//                     )),
//                   ]))
//               .toList()),
//     ),
//   );
// }
