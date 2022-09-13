import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:janakalyan_admin/screen/maturity/handle_maturity.dart';
import 'package:janakalyan_admin/screen/maturity/handle_pending_maturity.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';

class CustomList2 extends StatelessWidget {
  final Maturity maturity;
  final bool isMatured;
  const CustomList2({Key? key, required this.maturity, required this.isMatured})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => isMatured
                ? HandleMaturity(maturity: maturity, isMatured: isMatured)
                : HandlePendingMaturity(
                    maturity: maturity, isMatured: isMatured),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: maturity.isPreMaturity == 1 ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name : ${maturity.custName}",
                      style: style,
                    ),
                    Text(
                        maturity.isPreMaturity == 1
                            ? "Pre Maturity Amnt(Rs): ${maturity.maturityAmount}"
                            : "Maturity Amnt(Rs): ${maturity.maturityAmount}/-",
                        style: style)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account : ${maturity.accountNumber}",
                      style: style,
                    ),
                    isMatured
                        ? Text(
                            maturity.isPreMaturity == 1
                                ? "Pre Maturity Charge(Rs): ${maturity.preMaturityCharge}"
                                : "Maturity Interest(Rs): ${maturity.maturityInterest}/-",
                            style: style)
                        : Text(
                            isMatured
                                ? "Net Payable Amount(Rs):  ${maturity.totalAmount}"
                                : "CollectorId:  ${maturity.collectorId}",
                            style: style),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        isMatured
                            ? "Process Date : ${formatDate(maturity.processDate)}"
                            : "Applied at: ${formatDate(maturity.submitDate)}",
                        style: style),
                    Text(
                      isMatured
                          ? "Net Payable Amount(Rs):  ${maturity.totalAmount}"
                          : "",
                      style: style,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
