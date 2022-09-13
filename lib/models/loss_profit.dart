class LossAndProfitModel {
  int? id;
  int? profit;
  int? loss;
  String? createdAT;
  String? particulars;
  String? type;
  int? balance;

  LossAndProfitModel(
      {this.id,
      this.profit,
      this.loss,
      this.createdAT,
      this.particulars,
      this.type,
      this.balance});

  LossAndProfitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profit = json['profit'];
    loss = json['loss'];
    createdAT = json['createdAT'];
    particulars = json['particulars'];
    type = json['type'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profit'] = this.profit;
    data['loss'] = this.loss;
    data['createdAT'] = this.createdAT;
    data['particulars'] = this.particulars;
    data['type'] = this.type;
    data['balance'] = this.balance;
    return data;
  }
}
