// To parse this JSON data, do
//
//     final loanRepayment = loanRepaymentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoanRepayment loanRepaymentFromJson(String str) => LoanRepayment.fromJson(json.decode(str));

String loanRepaymentToJson(LoanRepayment data) => json.encode(data.toJson());

class LoanRepayment {
    LoanRepayment({
        required this.id,
        required this.repaymentAmount,
        required this.loanAcNo,
        required this.createdAt,
        required this.collectorId,
        required this.accountCreatedAt,
        required this.loanInterest,
        required this.totalPaidAmount,
        required this.dueDate,
        required this.remLoanAmnt,
        required this.interestPaid,
        required this.collectionAmount,
    });

    final int id;
    final int repaymentAmount;
    final int loanAcNo;
    final String createdAt;
    final int collectorId;
    final String accountCreatedAt;
    final double loanInterest;
    final int totalPaidAmount;
    final String dueDate;
    final int remLoanAmnt;
    final double interestPaid;
    final int collectionAmount;

    factory LoanRepayment.fromJson(Map<String, dynamic> json) => LoanRepayment(
        id: json["id"],
        repaymentAmount: json["repaymentAmount"],
        loanAcNo: json["loanAcNo"],
        createdAt: json["createdAt"],
        collectorId: json["collectorId"],
        accountCreatedAt: json["accountCreatedAt"],
        loanInterest: json["loanInterest"].toDouble(),
        totalPaidAmount: json["totalPaidAmount"],
        dueDate: json["dueDate"],
        remLoanAmnt: json["remLoanAmnt"],
        interestPaid: json["interestPaid"].toDouble(),
        collectionAmount: json["collectionAmount"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "repaymentAmount": repaymentAmount,
        "loanAcNo": loanAcNo,
        "createdAt": createdAt,
        "collectorId": collectorId,
        "accountCreatedAt": accountCreatedAt,
        "loanInterest": loanInterest,
        "totalPaidAmount": totalPaidAmount,
        "dueDate": dueDate,
        "remLoanAmnt": remLoanAmnt,
        "interestPaid": interestPaid,
        "collectionAmount": collectionAmount,
    };
}
