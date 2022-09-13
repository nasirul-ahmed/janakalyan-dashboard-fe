import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:janakalyan_admin/services/deposits/deposits_services.dart';
import 'package:janakalyan_admin/services/maturity/maturity.services.dart';

import 'package:janakalyan_admin/widgets/custom_list.dart';
import 'package:janakalyan_admin/widgets/custom_list2.dart';

class MaturityList extends StatelessWidget {
  MaturityList({Key? key}) : super(key: key);
  MaturityServices maturityServices = MaturityServices();
  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text("Pendings Deposits"),
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
                    child: const Center(
                      child: Text("Pending Maturities",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
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
                    child: const Center(
                      child: Text(
                        "Processing Maturities",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                child: SingleChildScrollView(
                  child: CustomMaturityList(
                      callback: maturityServices.getPendingMaturity,
                      processed: false),
                ),
              ),
              Expanded(
                child: CustomMaturityList(
                    callback: maturityServices.getProcessMaturity,
                    processed: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomMaturityList extends StatelessWidget {
  TaskCallback callback;
  final bool processed;

  CustomMaturityList(
      {Key? key, required this.callback, required this.processed})
      : super(key: key);
  DepositsServices x = DepositsServices();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Maturity>>(
        future: callback(),
        builder: (_, snap) {
          if (snap.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snap.hasData) {
            return SingleChildScrollView(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snap.data!.length,
                  itemBuilder: (_, id) {
                    // print(snap.data![id].accountNumber);
                    return CustomList2(
                        maturity: snap.data![id], isMatured: processed
                        // isDeposit: true,
                        // accept: () {},
                        // reject: () {
                        //   x.rejectDeposit;
                        // },
                        );
                  }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}
