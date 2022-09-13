class Cashbook {
  int? id;
  int? collectorId;
  String? extra;
  String? particulars;
  String? createdAt;
  int? credit;
  int? debit;
  int? amount;
  int? balance;

  Cashbook(
      {this.id,
      this.collectorId,
      this.extra,
      this.particulars,
      this.createdAt,
      this.credit,
      this.debit,
      this.amount,
      this.balance});

  Cashbook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    collectorId = json['collectorId'];
    extra = json['extra'];
    particulars = json['particulars'];
    createdAt = json['createdAt'];
    credit = json['credit'];
    debit = json['debit'];
    amount = json['amount'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['collectorId'] = collectorId;
    data['extra'] = extra;
    data['particulars'] = particulars;
    data['createdAt'] = createdAt;
    data['credit'] = credit;
    data['debit'] = debit;
    data['amount'] = amount;
    data['balance'] = balance;
    return data;
  }
}
