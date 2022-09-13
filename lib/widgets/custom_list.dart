import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/screen/accept_money/pending_deposits.dart';
import 'package:janakalyan_admin/services/deposits/deposits_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';

class CustomList extends StatelessWidget {
  final dynamic data;
  final bool isDeposit;

  CustomList({
    Key? key,
    required this.data,
    required this.isDeposit,
  }) : super(key: key);

  DepositsServices x = DepositsServices();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 17);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Collector Id: ${isDeposit ? data.collectorId : data.collector} ",
                    style: style,
                  ),
                  Text("Amount Rs: ${data.amount}", style: style)
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: isDeposit
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Commission Rs: ${data.commission}", style: style),
                        Text("Deposit date: ${formatDate(data.createdAt)} ",
                            style: style)
                      ],
                    )
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          "Deposit date: ${formatDate(data.createdAt)} ",
                          style: style),
                    ),
            ),
            Container(
                height: 25,
                color: Colors.white,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.red,
                        child: InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Reject Deposits!',
                              desc: 'Reject Amount Rs: ${data.amount}',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                http.Response res = isDeposit
                                    ? await x.rejectDeposit(
                                        data.amount, data.collectorId, data.id)
                                    : await x.rejectLoanDeposit(
                                        data.amount, data.collectorId, data.id);

                                if (200 == res.statusCode) {
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      title: "Successfully Rejected",
                                      btnOkOnPress: () {
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PendingDeposits()));
                                      });
                                } else {
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      title: "Error",
                                      btnOkOnPress: () {
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PendingDeposits()));
                                      });
                                }
                              },
                            )..show();
                          },
                          child: const Center(
                            child: Text("Reject",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        child: InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Reject Deposits!',
                              desc: 'Reject Amount Rs: ${data.amount}',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                http.Response res = isDeposit
                                    ? await x.acceptDeposits(
                                        data.amount,
                                        data.collectorId,
                                        data.id,
                                        data.createdAt)
                                    : await x.acceptLoanDeposits(data.id);
                                // (
                                //     data.amount, data.collectorId, data.id);

                                if (200 == res.statusCode) {
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      title: "Successfully Rejected",
                                      btnOkOnPress: () {
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PendingDeposits()));
                                      });
                                } else {
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      title: "Error",
                                      btnOkOnPress: () {
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    PendingDeposits()));
                                      });
                                }
                              },
                            )..show();
                          },
                          child: const Center(
                            child: Text("Accept",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
