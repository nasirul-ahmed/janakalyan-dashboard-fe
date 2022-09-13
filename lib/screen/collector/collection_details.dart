import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/collector_model.dart';
import 'package:janakalyan_admin/screen/commission/comission.dart';
import 'package:janakalyan_admin/screen/commission/commission_history.dart';
import 'package:janakalyan_admin/screen/deposit_history/collector_deposits.dart';
import 'package:janakalyan_admin/screen/transactions/deposits_till_day.dart';
import 'package:janakalyan_admin/services/today_collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CollectionDetails extends StatefulWidget {
  final Collector? collector;
  const CollectionDetails({Key? key, this.collector}) : super(key: key);

  @override
  State<CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<CollectionDetails> {
  @override
  void initState() {
    super.initState();
  }

  Future<num?> todayCollection() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/today-collection/collector');
    var selectedDate = DateTime.now();
    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector!.id,
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

  Future<num?> todayLoanCollection() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/todays-loan-collection');
    var selectedDate = DateTime.now();
    var jsonBody = jsonEncode(<String, dynamic>{
      "id": widget.collector!.id,
      "date": DateTime.now().toString().split(" ")[0]
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
        return parsed["todaysLoanCollection"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> getAllTimeDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        "$janaklyan/api/admin/all-time-deposits/${widget.collector!.id}");
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        //print(res.body);
        return parsed[0]["allTimelDeposits"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> thisMonthsDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("$janaklyan/api/admin/monthly-deposits");
    //final url = Uri.parse("uri");
    final date = DateTime.now();
    var body = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector!.id,
      "createdAt": "$date"
    });
    try {
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          },
          body: body);
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed[0]["deposits"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.collectorId);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Collectors"),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 500) {
              return DesktopView(
                  collector: widget.collector!,
                  getAllTimeDeposits: getAllTimeDeposits,
                  thisMonthsDeposits: thisMonthsDeposits,
                  todayCollection: todayCollection,
                  todayLoanCollection: todayLoanCollection);
            } else {
              return MobileView(
                  collector: widget.collector!,
                  getAllTimeDeposits: getAllTimeDeposits,
                  thisMonthsDeposits: thisMonthsDeposits,
                  todayCollection: todayCollection,
                  todayLoanCollection: todayLoanCollection);
            }
          },
        ));
  }
}

class MobileView extends StatelessWidget {
  const MobileView({
    Key? key,
    required this.collector,
    required this.getAllTimeDeposits,
    required this.thisMonthsDeposits,
    required this.todayCollection,
    required this.todayLoanCollection,
  }) : super(key: key);
  final Collector collector;
  final VoidCallback getAllTimeDeposits;
  final VoidCallback thisMonthsDeposits;
  final VoidCallback todayCollection;
  final VoidCallback todayLoanCollection;
  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Option(
                label: "Collector Code ${collector.id}",
                height: 70.0,
              ),
            ],
          ),
          Row(
            children: [
              Option3(
                callback: getAllTimeDeposits,
                style: style,
                label: "All Time Deposits",
                callback2: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CollectorTransactions(collector.id),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              Option3(
                style: style,
                callback: thisMonthsDeposits,
                label: "This Month's Deposits",
                callback2: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CollectorDeposits(collector.id),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              Option2(
                collection: collector.totalCollection,
                label: "Deposit Amount in Wallet",
              ),
            ],
          ),
          Row(
            children: [
              Option2(
                collection: collector.totalLoanCollection,
                label: "Loan Amount in Wallet",
              ),
            ],
          ),
          Row(
            children: [
              Option3(
                callback: todayCollection,
                style: style,
                label: "Today's Collection",
                callback2: () => null,
              ),
            ],
          ),
          Row(
            children: [
              Option3(
                  style: style,
                  callback: todayLoanCollection,
                  label: "Today's Loan Collection",
                  callback2: null),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    height: 60,
                    color: Colors.blueGrey,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Commission(
                              collector: collector.id,
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Pay Commission",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    height: 60,
                    color: Colors.blueGrey,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommissionHistory(
                              collectorId: collector.id,
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          "Commission History",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DesktopView extends StatelessWidget {
  const DesktopView({
    Key? key,
    required this.collector,
    required this.getAllTimeDeposits,
    required this.thisMonthsDeposits,
    required this.todayCollection,
    required this.todayLoanCollection,
  }) : super(key: key);
  final Collector collector;
  final VoidCallback getAllTimeDeposits;
  final VoidCallback thisMonthsDeposits;
  final VoidCallback todayCollection;
  final VoidCallback todayLoanCollection;
  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
    return Column(
      children: [
        Row(
          children: [
            Option(
              label: "Collector Code ${collector.id}",
              height: 70.0,
            ),
          ],
        ),
        Row(
          children: [
            Option3(
              callback: getAllTimeDeposits,
              style: style,
              label: "All Time Deposits",
              callback2: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CollectorTransactions(collector.id),
                  ),
                );
              },
            ),
            Option3(
              style: style,
              callback: thisMonthsDeposits,
              label: "This Month's Deposits",
              callback2: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CollectorDeposits(collector.id),
                  ),
                );
              },
            )
          ],
        ),
        Row(
          children: [
            Option2(
              collection: collector.totalCollection,
              label: "Deposit Collection Amount in Wallet",
            ),
            Option2(
              collection: collector.totalLoanCollection,
              label: "Loan Collection Amount in Wallet",
            ),
          ],
        ),
        Row(
          children: [
            Option3(
              callback: todayCollection,
              style: style,
              label: "Today's Collection",
              callback2: () => null,
            ),
            Option3(
                style: style,
                callback: todayLoanCollection,
                label: "Today's Loan Collection",
                callback2: null)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            height: 60,
            color: Colors.blueGrey,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Commission(
                      collector: collector.id,
                    ),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "Pay Commission",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            height: 60,
            color: Colors.blueGrey,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommissionHistory(
                      collectorId: collector.id,
                    ),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "Commission History",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Option3 extends StatelessWidget {
  final TextStyle? style;
  final TaskCallback callback;
  final TaskCallback? callback2;
  final String label;

  // ignore: prefer_const_constructors_in_immutables
  Option3(
      {Key? key,
      required this.style,
      required this.callback,
      required this.label,
      this.callback2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () => callback2!(),
          child: Container(
            //width: screen.width * 0.34,
            height: 70,
            color: Colors.blueGrey[600],
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toString(),
                    style: style,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<num?>(
                      future: callback(),
                      builder: (_, snap) {
                        if (snap.hasError) {
                          return const Center(
                            child: Text("No Collectors"),
                          );
                        } else if (snap.hasData) {
                          return Text(
                            "${snap.data}",
                            style: style,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Option2 extends StatelessWidget {
  final String? label;
  final int? collection;
  Option2({Key? key, this.collection, this.label}) : super(key: key);
  var style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 5,
        child: Container(
          //width: screen.width * 0.34,
          height: 70,
          color: Colors.red,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label ?? "",
                  style: style,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  collection.toString(),
                  style: style,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String? label;
  final double? height;

  const Option({Key? key, this.label, this.height}) : super(key: key);
  final style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Expanded(
      child: Card(
        elevation: 5,
        child: Container(
          //width: screen.width * 0.34,
          height: height,
          color: Colors.red,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "$label",
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
