import 'dart:convert';

import 'package:janakalyan_admin/screen/deposit_history/deposit_history.dart';

DepositHistoryModel depositTnxModelFromJson(String str) =>
    DepositHistoryModel.fromJson(json.decode(str));

String depositTnxModelToJson(DepositHistoryModel data) =>
    json.encode(data.toJson());

class DepositHistoryModel {
  DepositHistoryModel({
    this.id,
    this.collectorId,
    this.amount,
    this.createdAt,
    this.currentStatus,
    this.commission,
  });

  int? id;
  int? collectorId;
  int? amount;
  String? createdAt;
  int? currentStatus;
  double? commission;

  factory DepositHistoryModel.fromJson(Map<String, dynamic> json) =>
      DepositHistoryModel(
        id: json["id"],
        collectorId: json["collectorId"],
        amount: json["amount"],
        createdAt: json["createdAt"],
        currentStatus: json["currentStatus"],
        commission: json["commission"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectorId": collectorId,
        "amount": amount,
        "createdAt": createdAt,
        "currentStatus": currentStatus,
        "commission": commission,
      };
}
