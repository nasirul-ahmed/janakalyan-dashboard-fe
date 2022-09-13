// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

LoanCustomer customerFromJson(String str) =>
    LoanCustomer.fromJson(json.decode(str));

String customerToJson(LoanCustomer data) => json.encode(data.toJson());

class LoanCustomer {
  LoanCustomer({
    this.id,
    this.collectorId,
    this.createdAt,
    this.custName,
    this.depositAcNo,
    this.loanAcNo,
    this.loanAmount,
    this.loanInterest,
    this.totalCollection,
    this.dueDays,
    this.interestRate,
    this.updatedAt,
    this.dueDate,
    this.remLoanAmnt,
  });

  final int? id;
  final int? loanAcNo;
  final int? depositAcNo;
  final String? custName;
  final int? collectorId;
  final String? createdAt;
  final num? loanAmount;
  final num? totalCollection;
  final num? loanInterest;
  final int? dueDays;
  final num? interestRate;
  final String? updatedAt;
  final String? dueDate;
  final num? remLoanAmnt;

  factory LoanCustomer.fromJson(Map<String, dynamic> json) => LoanCustomer(
      id: json["id"],
      loanAcNo: json["loanAcNo"],
      depositAcNo: json["depositAcNo"],
      custName: json["custName"],
      collectorId: json["collectorId"],
      createdAt: json["createdAt"],
      totalCollection: json["totalCollection"],
      loanAmount: json["loanAmount"],
      loanInterest: json["loanInterest"],
      dueDays: json["dueDays"],
      interestRate: json["interestRate"],
      updatedAt: json["updatedAt"],
      dueDate: json["dueDate"],
      remLoanAmnt: json["remLoanAmnt"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "loanAcNo": loanAcNo,
        "depositAcNo": depositAcNo,
        "custName": depositAcNo,
        "collectorId": collectorId,
        "createdAt": collectorId,
        "totalCollection": totalCollection,
        "loanAmount": loanAmount,
        "loanInterest": loanInterest,
        "dueDays": dueDays,
        "interestRate": interestRate,
        "updatedAt": updatedAt,
        "dueDate": dueDate,
        "remLoanAmnt": remLoanAmnt
      };
}
