// To parse this JSON data, do
//
//     final commission = commissionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Commission commissionFromJson(String str) => Commission.fromJson(json.decode(str));

String commissionToJson(Commission data) => json.encode(data.toJson());

class Commission {
    Commission({
        required this.id,
        required this.commissionPaid,
        required this.createdAt,
        required this.collectorId,
        required this.payMonth,
    });

    final int id;
    final int commissionPaid;
    final DateTime createdAt;
    final int collectorId;
    final DateTime payMonth;

    factory Commission.fromJson(Map<String, dynamic> json) => Commission(
        id: json["id"],
        commissionPaid: json["commissionPaid"],
        createdAt: DateTime.parse(json["createdAt"]),
        collectorId: json["collectorId"],
        payMonth: DateTime.parse(json["payMonth"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "commissionPaid": commissionPaid,
        "createdAt": createdAt.toIso8601String(),
        "collectorId": collectorId,
        "payMonth": payMonth.toIso8601String(),
    };
}
