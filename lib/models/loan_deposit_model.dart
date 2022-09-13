import 'dart:convert';

LoanDepositModel loanDepositModelFromJson(String str) =>
    LoanDepositModel.fromJson(json.decode(str));

String loanDepositModelToJson(LoanDepositModel data) =>
    json.encode(data.toJson());

class LoanDepositModel {
  LoanDepositModel({
    this.id,
    this.collector,
    this.amount,
    this.createdAt,
    this.currentStatus,
  });

  int? id;
  int? collector;
  int? amount;
  String? createdAt;
  int? currentStatus;

  factory LoanDepositModel.fromJson(Map<String, dynamic> json) =>
      LoanDepositModel(
        id: json["id"],
        collector: json["collector"],
        amount: json["amount"],
        createdAt: json["createdAt"],
        currentStatus: json["currentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "collector": collector,
        "amount": amount,
        "createdAt": createdAt,
        "currentStatus": currentStatus,
      };
}
