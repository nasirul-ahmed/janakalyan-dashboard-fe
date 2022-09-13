class Salary {
  int? id;
  int? empNo;
  String? createdAt;
  String? employeeName;
  int? salaryAmount;

  Salary({
    this.id,
    this.empNo,
    this.createdAt,
    this.employeeName,
    this.salaryAmount,
  });

  Salary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empNo = json['empNo'];
    createdAt = json['createdAt'];
    employeeName = json['employeeName'];
    salaryAmount = json['salaryAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['empNo'] = empNo;
    data['createdAt'] = createdAt;
    data['employeeName'] = employeeName;
    data['salaryAmount'] = salaryAmount;

    return data;
  }
}
