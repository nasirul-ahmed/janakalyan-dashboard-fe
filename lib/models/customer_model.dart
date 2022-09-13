// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer(
      {this.id,
      this.accountNumber,
      this.name,
      this.fatherName,
      this.address,
      this.pinCode,
      this.occupation,
      this.nomineeName,
      this.nomineeAddress,
      this.nomineePhone,
      this.relation,
      this.nomineeFatherName,
      this.rateOfInterest,
      this.totalInstallments,
      this.installmentAmount,
      this.maturityDate,
      this.totalPrincipalAmount,
      this.totalInterestAmount,
      this.totalMaturityAmount,
      this.agentUid,
      this.createdAt,
      this.phone,
      this.age,
      this.accountType,
      this.profile,
      this.signature,
      this.totalCollection,
      this.nomineeAge,
      this.isActive,
      this.loanAccountNumber});

  int? id;
  int? accountNumber;
  String? name;
  String? fatherName;
  String? address;
  int? pinCode;
  String? occupation;
  String? nomineeName;
  String? nomineeAddress;
  int? nomineePhone;
  String? relation;
  String? nomineeFatherName;
  int? rateOfInterest;
  int? totalInstallments;
  int? installmentAmount;
  String? maturityDate;
  num? totalPrincipalAmount;
  num? totalInterestAmount;
  num? totalMaturityAmount;
  String? agentUid;
  String? createdAt;
  int? phone;
  int? age;
  int? nomineeAge;
  String? accountType;
  String? profile;
  String? signature;
  num? totalCollection;
  int? isActive;
  int? loanAccountNumber;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        accountNumber: json["accountNumber"],
        name: json["name"],
        fatherName: json["fatherName"],
        address: json["address"],
        pinCode: json["pinCode"],
        occupation: json["occupation"],
        nomineeName: json["nomineeName"],
        nomineeAddress: json["nomineeAddress"],
        nomineePhone: json["nomineePhone"],
        relation: json["relation"],
        nomineeFatherName: json["nomineeFatherName"],
        rateOfInterest: json["rateOfInterest"],
        totalInstallments: json["totalInstallments"],
        installmentAmount: json["installmentAmount"],
        maturityDate: json["maturityDate"],
        totalPrincipalAmount: json["totalPrincipalAmount"],
        totalInterestAmount: json["totalInterestAmount"],
        totalMaturityAmount: json["totalMaturityAmount"],
        agentUid: json["agentUid"],
        createdAt: json["createdAt"],
        phone: json["phone"],
        age: json["age"],
        nomineeAge: json["nomineeAge"],
        accountType: json["accountType"],
        profile: json["profile"],
        signature: json["signature"],
        totalCollection: json["totalCollection"],
        isActive: json["isActive"],
        loanAccountNumber: json["loanAccountNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountNumber": accountNumber,
        "name": name,
        "fatherName": fatherName,
        "address": address,
        "pinCode": pinCode,
        "occupation": occupation,
        "nomineeName": nomineeName,
        "nomineeAddress": nomineeAddress,
        "nomineePhone": nomineePhone,
        "relation": relation,
        "nomineeFatherName": nomineeFatherName,
        "rateOfInterest": rateOfInterest,
        "totalInstallments": totalInstallments,
        "installmentAmount": installmentAmount,
        "maturityDate": maturityDate,
        "totalPrincipalAmount": totalPrincipalAmount,
        "totalInterestAmount": totalInterestAmount,
        "totalMaturityAmount": totalMaturityAmount,
        "agentUid": agentUid,
        "createdAt": createdAt,
        "phone": phone,
        "age": age,
        "nomineeAge": nomineeAge,
        "accountType": accountType,
        "profile": profile,
        "signature": signature,
        "totalCollection": totalCollection,
        "isActive": isActive,
        "loanAccountNumber": loanAccountNumber
      };
}
