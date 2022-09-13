import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_customer.dart';
import 'package:janakalyan_admin/models/loan_transaction.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanPassbook extends StatelessWidget {
  const LoanPassbook({Key? key, required this.doc}) : super(key: key);
  final LoanCustomer? doc;

  Future<List<LoanTransactionsModel>> getLoanTransactions() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse("$janaklyan/api/admin/get-loan-trans-by-ac");

    var body =
        jsonEncode(<String, dynamic>{"loanAccountNumber": doc!.loanAcNo});

    try {
      var res = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}",
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        return parsed
            .map<LoanTransactionsModel>(
                (json) => LoanTransactionsModel.fromJson(json))
            .toList();
      }

      return List<LoanTransactionsModel>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Passbook'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                height: 150,
                width: MediaQuery.of(context).size.width * .6,
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
                            'Name :  ${doc!.custName}',
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
                            'Account No :  ${doc!.loanAcNo}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Deposit Ac :  ${doc!.depositAcNo}',
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
                            'Loan Sanctioned :  ${doc!.loanAmount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Coming Due Date :  ${formatDate(doc!.dueDate)}',
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
            FutureBuilder<List<LoanTransactionsModel>>(
                future: getLoanTransactions(),
                builder: (_, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text(
                        'Account Number :  ${doc!.loanAcNo}',
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

  SingleChildScrollView renderDatatable(List<LoanTransactionsModel>? list) {
    ScrollController x = ScrollController();
    const style = TextStyle(color: Colors.black, fontSize: 16);
    const style1 = TextStyle(color: Colors.black, fontSize: 16);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        controller: x,
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
                .map((LoanTransactionsModel document) => DataRow(cells: [
                      DataCell(Text(
                        '${document.id}',
                        style: style,
                      )),
                      DataCell(Text(
                        '${formatDate(document.createdAt)}',
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
}
