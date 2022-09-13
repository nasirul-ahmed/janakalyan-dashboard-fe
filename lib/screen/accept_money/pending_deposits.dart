import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:janakalyan_admin/models/deposit_history_model.dart';
import 'package:janakalyan_admin/models/loan_deposit_model.dart';
import 'package:janakalyan_admin/services/deposits/deposits_services.dart';

import 'package:janakalyan_admin/widgets/custom_list.dart';

class PendingDeposits extends StatelessWidget {
  PendingDeposits({Key? key}) : super(key: key);
  DepositsServices depositsServices = DepositsServices();
  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title:const Text("Pendings Deposits"),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: Colors.blueGrey[600],
                    child: Center(
                      child: Text("Pending Deposits", style: style),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: Colors.blueGrey[600],
                    child: Center(
                      child: Text(
                        "Pending Loan Deposits",
                        style: style,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomLoanApplication(
                  callback: depositsServices.pendings,
                ),
              ),
              Expanded(
                child: CustomPendingLoanDeposits(
                  callback: depositsServices.pendingsLoanDeposits,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomLoanApplication extends StatelessWidget {
  TaskCallback callback;

  CustomLoanApplication({
    Key? key,
    required this.callback,
  }) : super(key: key);
  DepositsServices x = DepositsServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DepositHistoryModel>>(
      future: callback(),
      builder: (_, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snap.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.data!.length,
              itemBuilder: (_, id) {
                return CustomList(
                  data: snap.data![id],
                  isDeposit: true,
                  // accept: () {},
                  // reject: () {
                  //   x.rejectDeposit;
                  // },
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}

class CustomPendingLoanDeposits extends StatelessWidget {
  TaskCallback callback;

  CustomPendingLoanDeposits({Key? key, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LoanDepositModel>>(
      future: callback(),
      builder: (_, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snap.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.data!.length,
              itemBuilder: (_, id) {
                return CustomList(
                  data: snap.data![id],
                  isDeposit: false,
                  // accept: () {},
                  // reject: () {},
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}

