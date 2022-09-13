import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/models/transaction_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepositPassbook extends StatelessWidget {
  const DepositPassbook({Key? key, required this.doc}) : super(key: key);
  final Customer? doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Passbook'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: 100,
                width: MediaQuery.of(context).size.width *.6,
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name :  ${doc!.name}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Collection Amnt : ${doc!.totalCollection}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account No :  ${doc!.accountNumber}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Opening Date :  ${formatDate(doc!.createdAt)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<TransactionsModel>>(
                future: getTransactions(),
                builder: (_, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text(
                        'Account Number :  ${doc!.accountNumber}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snap.hasData) {
                    return Center(child: renderDatatable(snap.data));
                  }
                  return Container(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  SingleChildScrollView renderDatatable(List<TransactionsModel>? list) {
    const style = TextStyle(color: Colors.black, fontSize: 16);
    const style1 = TextStyle(color: Colors.black, fontSize: 16);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            // columnSpacing: 25,
            // horizontalMargin: 10,
            columns: [
              DataColumn(label: Text('C.Id', style: style1)),
              DataColumn(label: Text('Date', style: style1)),
              DataColumn(label: Text('Daily C.', style: style1)),
              DataColumn(label: Text('Total C.', style: style1)),
            ],
            rows: list!
                .map((TransactionsModel document) => DataRow(cells: [
                      DataCell(Text(
                        '${document.id}',
                        style: style,
                      )),
                      DataCell(Text(
                        '${formatDate(document.date)}',
                        style: style,
                      )),
                      DataCell(Text(
                        '${document.amount}',
                        style: style,
                      )),
                      DataCell(Text(
                        '${document.totalCollection}',
                        style: style,
                      )),
                    ]))
                .toList()),
      ),
    );
  }

  Future<List<TransactionsModel>> getTransactions() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse("$janaklyan/api/admin/get-trans-by-ac");

    var body =
        jsonEncode(<String, dynamic>{"accountNumber": doc!.accountNumber});

    try {
      var res = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}",
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<TransactionsModel>((json) => TransactionsModel.fromJson(json))
            .toList();
      }

      return List<TransactionsModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }
}
