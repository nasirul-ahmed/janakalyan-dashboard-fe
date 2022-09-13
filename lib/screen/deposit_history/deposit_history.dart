import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/deposit_history_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DepositHistory extends StatefulWidget {
  const DepositHistory({Key? key}) : super(key: key);

  @override
  _DepositHistoryState createState() => _DepositHistoryState();
}

class _DepositHistoryState extends State<DepositHistory> {
  Future<List<DepositHistoryModel>> getCustomerDepositHistory() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/success-deposits');
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
        title: const Text("Deposit Collection Details"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      "All Regular deposits",
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
                child: FutureBuilder<List<DepositHistoryModel>>(
                    future: getCustomerDepositHistory(),
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
  final DepositHistoryModel depositHistoryModel;
  const CustomListTile({Key? key, required this.depositHistoryModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text("Amount: ${depositHistoryModel.amount}"),
        subtitle: Text("Collector ID: ${depositHistoryModel.collectorId}"),
        trailing: Text("Date : ${formatDate(depositHistoryModel.createdAt)}"),
      ),
    );
  }
}
