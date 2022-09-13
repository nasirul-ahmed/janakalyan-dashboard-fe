// id int(11) AI PK
// collectorId int(11)
// depositAcNo int(11)
// createdAt date
// loanAmount double
// isSanctioned tinyint(1)

class LoanApplicationModel {
  LoanApplicationModel(
      {this.id,
      this.collectorId,
      this.loanAmount,
      this.createdAt,
      this.depositAcNo,
      this.isSanctioned,
      this.processDate,
      this.custName});
  int? id;
  int? collectorId;
  int? loanAmount;
  String? createdAt;
  int? depositAcNo;
  String? processDate;
  int? isSanctioned;
  String? custName;

  factory LoanApplicationModel.fromJson(Map<String, dynamic> json) =>
      LoanApplicationModel(
          id: json["id"],
          collectorId: json["collectorId"],
          loanAmount: json["loanAmount"],
          createdAt: json["createdAt"],
          depositAcNo: json["depositAcNo"],
          processDate: json["processDate"],
          isSanctioned: json["isSanctioned"],
          custName: json["custName"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "collectorId": collectorId,
        "loanAmount": loanAmount,
        "createdAt": createdAt,
        "depositAcNo": depositAcNo,
        "processDate": processDate,
        "isSanctioned": isSanctioned,
        "custName": custName
      };
}
