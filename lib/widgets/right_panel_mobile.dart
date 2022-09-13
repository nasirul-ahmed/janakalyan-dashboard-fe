import 'package:flutter/material.dart';
import 'package:janakalyan_admin/screen/accept_money/pending_deposits.dart';
import 'package:janakalyan_admin/screen/cashbook/cashbook.dart';
import 'package:janakalyan_admin/screen/collector/collector_details.dart';
import 'package:janakalyan_admin/screen/deposit_history/deposit_history.dart';
import 'package:janakalyan_admin/screen/expenses/expenses_type.dart';
import 'package:janakalyan_admin/screen/handle_loan/search_loan.dart';
import 'package:janakalyan_admin/screen/loan_application/loan_application.dart';
import 'package:janakalyan_admin/screen/loan_deposit/loan_deposit_history.dart';
import 'package:janakalyan_admin/screen/loss_profit/loss_profit.dart';
import 'package:janakalyan_admin/screen/management/management.dart';
import 'package:janakalyan_admin/screen/maturity/maturity_list.dart';
import 'package:janakalyan_admin/services/todays_collection/todays_collection.dart';

class RightPanelDeskTop extends StatefulWidget {
  const RightPanelDeskTop({Key? key, required this.reload}) : super(key: key);
  final int reload;

  @override
  _RightPanelDeskTopState createState() => _RightPanelDeskTopState();
}

class _RightPanelDeskTopState extends State<RightPanelDeskTop> {
  TodayCollection x = TodayCollection();
  @override
  Widget build(BuildContext context) {
    print(widget.reload);
    const style = TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 100,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DepositHistory(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 15,
                      child: Container(
                        height: 180,
                        color: Colors.orange[900],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Deposits Collection",
                              style: style,
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder<num?>(
                              future: x.todaysDepositsC(),
                              builder: (_, snap) {
                                if (snap.hasError) {
                                  return const Text("error");
                                } else if (snap.hasData) {
                                  return Text(
                                      "Rs: " + snap.data.toString() + "/-",
                                      style: style);
                                } else {
                                  return const CircularProgressIndicator
                                      .adaptive();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoanDepositHistory(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 15,
                      child: Container(
                        height: 180,
                        color: Colors.orange[900],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Loan Collection",
                              style: style,
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder<num?>(
                                future: x.todaysLoanC(),
                                builder: (_, snap) {
                                  if (snap.hasError) {
                                    return const Text("error");
                                  } else if (snap.hasData) {
                                    return Text(
                                        "Rs: " + snap.data.toString() + "/-",
                                        style: style);
                                  } else {
                                    return const CircularProgressIndicator
                                        .adaptive();
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CollectorDetails()));
                    },
                    child: const Ooptions2(
                      label: "Collector Details",
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CashbookDetails()));
                    },
                    child: const Ooptions2(
                      label: "Cashbook",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoanApplication()));
                    },
                    child: const Ooptions2(
                      label: "Loan Application",
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SearchLoan()));
                    },
                    child: const Ooptions2(
                      label: "Loan Details",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ManagementSystem()));
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * .66,
                        color: Colors.red,
                        child: const Center(
                          child: Text(
                            "Management Sytem",
                            style: style,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => PendingDeposits()));
                    },
                    child: const Ooptions2(
                      label: "Accept Money",
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MaturityList()));
                    },
                    child: const Ooptions2(
                      label: "Maturity",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ExpensesType()));
                    },
                    child: const Ooptions2(
                      label: "Expenses",
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LossAndProfit()));
                    },
                    child: const Ooptions2(
                      label: "Loss & Profit",
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Ooptions extends StatelessWidget {
  final String? label;
  final String? rupees;
  const Ooptions({Key? key, @required this.label, this.rupees})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
    return Card(
      elevation: 5,
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width * 0.33,
        color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$label",
              style: style,
            ),
            const SizedBox(height: 10),
            Text(
              "RS. $rupees",
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class Ooptions2 extends StatelessWidget {
  final String? label;

  const Ooptions2({Key? key, this.label}) : super(key: key);
  final style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
        width: screen.width * 0.33,
        height: 100.0,
        color: Colors.green,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "$label",
            style: style,
          ),
        ),
      ),
    );
  }
}
