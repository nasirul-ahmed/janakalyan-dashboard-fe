import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_deposit_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoanDepositHistory extends StatefulWidget {
  const LoanDepositHistory({Key? key}) : super(key: key);

  @override
  _LoanDepositHistoryState createState() => _LoanDepositHistoryState();
}

class _LoanDepositHistoryState extends State<LoanDepositHistory> {
  Future<List<LoanDepositModel>> getLoanDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/loan-deposit');
    //final url =Uri.parse("uri");
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
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Collection Details"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.6,
              height: 100,
              color: Colors.blueAccent,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Center(
                    child: Text(
                      "All Loan deposits",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: FutureBuilder<List<LoanDepositModel>>(
                    future: getLoanDeposits(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const Text("Somethings not right");
                      } else if (snap.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.data!.length,
                            itemBuilder: (context, id) {
                              return CustomListTile(
                                  depositHistoryModel: snap.data![id]);
                            });
                      } else {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final LoanDepositModel depositHistoryModel;
  const CustomListTile({Key? key, required this.depositHistoryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text("Amount: ${depositHistoryModel.amount}"),
        subtitle: Text("Collector ID: ${depositHistoryModel.collector}"),
        trailing: Text("Date : ${formatDate(depositHistoryModel.createdAt)}"),
      ),
    );
  }
}
