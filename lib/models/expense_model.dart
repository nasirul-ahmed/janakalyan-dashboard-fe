class ExpenseModel {
  int? id;
  int? amount;
  String? particulars;
  String? createdAt;
  int? flag;
  int? empNo;

  ExpenseModel(
      {this.id,
      this.amount,
      this.particulars,
      this.createdAt,
      this.flag,
      this.empNo});

  ExpenseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    particulars = json['particulars'];
    createdAt = json['createdAt'];
    flag = json['flag'];
    empNo = json['emp_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['particulars'] = this.particulars;
    data['createdAt'] = this.createdAt;
    data['flag'] = this.flag;
    data['emp_no'] = this.empNo;
    return data;
  }
}
