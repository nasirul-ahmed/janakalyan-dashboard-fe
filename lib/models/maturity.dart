class Maturity {
  int? id;
  int? accountNumber;
  String? custName;
  int? maturityValue;
  String? closingDate;
  int? maturityAmount;
  int? maturityInterest;
  int? totalAmount;
  int? collectorId;
  int? isMatured;
  int? preMaturityCharge;
  int? isPreMaturity;
  String? processDate;
  String? submitDate;
  String? fathersName;
  String? address;
  String? openingDate;
  int? loss;

  Maturity(
      {this.id,
      this.accountNumber,
      this.custName,
      this.maturityValue,
      this.closingDate,
      this.maturityAmount,
      this.maturityInterest,
      this.totalAmount,
      this.collectorId,
      this.isMatured,
      this.preMaturityCharge,
      this.isPreMaturity,
      this.processDate,
      this.submitDate,
      this.fathersName,
      this.address,
      this.openingDate,
      this.loss});

  Maturity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountNumber = json['accountNumber'];
    custName = json['custName'];
    maturityValue = json['maturityValue'];
    closingDate = json['closingDate'];
    maturityAmount = json['maturityAmount'];
    maturityInterest = json['maturityInterest'];
    totalAmount = json['totalAmount'];
    collectorId = json['collectorId'];
    isMatured = json['isMatured'];
    preMaturityCharge = json['preMaturityCharge'];
    isPreMaturity = json['isPreMaturity'];
    processDate = json['processDate'];
    submitDate = json['submitDate'];
    fathersName = json['fathersName'];
    address = json['address'];
    openingDate = json['openingDate'];
    loss = json['loss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountNumber'] = this.accountNumber;
    data['custName'] = this.custName;
    data['maturityValue'] = this.maturityValue;
    data['closingDate'] = this.closingDate;
    data['maturityAmount'] = this.maturityAmount;
    data['maturityInterest'] = this.maturityInterest;
    data['totalAmount'] = this.totalAmount;
    data['collectorId'] = this.collectorId;
    data['isMatured'] = this.isMatured;
    data['preMaturityCharge'] = this.preMaturityCharge;
    data['isPreMaturity'] = this.isPreMaturity;
    data['processDate'] = this.processDate;
    data['submitDate'] = this.submitDate;
    data['fathersName'] = this.fathersName;
    data['address'] = this.address;
    data['openingDate'] = this.openingDate;
    data['loss'] = this.loss;
    return data;
  }
}
