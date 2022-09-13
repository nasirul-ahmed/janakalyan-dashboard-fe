class TransactionsModel {
  int? id;
  int? collector;
  int? amount;
  int? totalCollection;
  String? date;
  int? customer_account;

  TransactionsModel(
      {this.id,
      this.collector,
      this.amount,
      this.date,
      this.customer_account,
      this.totalCollection});

  factory TransactionsModel.fromJson(Map<String, dynamic> json) =>
      TransactionsModel(
          id: json["id"],
          collector: json["collector"],
          amount: json["amount"],
          date: json["date"],
          customer_account: json["customer_account"],
          totalCollection: json["totalCollection"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "collector": collector,
        "amount": amount,
        "date": date,
        "customer_account": customer_account,
        "totalCollection": totalCollection
      };
}
