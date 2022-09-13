// To parse this JSON data, do
//
//     final collector = collectorFromJson(jsonString);

import 'dart:convert';

Collector collectorFromJson(String str) => Collector.fromJson(json.decode(str));

String collectorToJson(Collector data) => json.encode(data.toJson());

class Collector {
  Collector({
    required this.id,
    required this.name,
    required this.email,
    required this.totalCollection,
    required this.totalLoanCollection,
  });

  final int id;
  final String name;
  final String email;
  final int totalCollection;
  final totalLoanCollection;

  factory Collector.fromJson(Map<String, dynamic> json) => Collector(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        totalCollection: json["totalCollection"],
        totalLoanCollection: json["totalLoanCollection"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "totalCollection": totalCollection,
        "totalLoanCollection": totalLoanCollection,
      };
}
