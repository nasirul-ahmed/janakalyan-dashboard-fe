import 'package:flutter/material.dart';
import 'package:janakalyan_admin/services/management_services/management.services.dart';

class ManagementSystem extends StatefulWidget {
  ManagementSystem({Key? key}) : super(key: key);

  @override
  State<ManagementSystem> createState() => _ManagementSystemState();
}

class _ManagementSystemState extends State<ManagementSystem> {
  ManagementServices managementServices = ManagementServices();
  bool isLoading = true;
  //maturity
  int totalMaturityAmount = 0;
  int totalMaturityInterestAmount = 0;
  int totalPrematurityChargeAmount = 0;
  int totalCoolectionAmount = 0;
  int totalDeposit = 0;
  //loan Re
  int totalLoanSanctioned = 0;
  int totalLoanCollected = 0;
  int totalRepaymentAmount = 0;
  int totalInterestPaid = 0;
  int closeLoanAmount = 0;
  //expense
  int totalExpenses = 0;
  int totalSalaries = 0;
  int loanServiceCharge = 0;
  int totalCommissionPaid = 0;

  getAll() async {
    var loan = await managementServices.loanRelatedAmounts();
    var expense = await managementServices.expenseRelatedAmounts();
    var maturity = await managementServices.maturityRelatedAmounts();

    setState(() {
      totalMaturityAmount = maturity["totalMaturityAmount"] ?? 0;
      totalMaturityInterestAmount =
          maturity["totalMaturityInterestAmount"] ?? 0;
      totalPrematurityChargeAmount =
          maturity["totalPrematurityChargeAmount"] ?? 0;
      totalCoolectionAmount = maturity["totalCoolectionAmount"] ?? 0;
      totalDeposit = maturity["totalDeposit"] ?? 0;

      totalLoanSanctioned = loan["totalLoanSanctioned"] ?? 0;
      totalLoanCollected = loan["totalLoanCollected"] ?? 0;
      totalRepaymentAmount = loan["totalRepaymentAmount"] ?? 0;
      totalInterestPaid = loan["totalInterestPaid"] ?? 0;
      closeLoanAmount = loan["closeLoanAmount"] ?? 0;

      totalExpenses = expense["totalExpenses"] ?? 0;
      totalSalaries = expense["totalSalaries"] ?? 0;
      loanServiceCharge = expense["loanServiceCharge"] ?? 0;
      totalCommissionPaid = expense["totalCommissionPaid"] ?? 0;

      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    const style2 = TextStyle(
        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Management System"),
      ),
      body: Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 30,
                        width: 300,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            "Maturity Related Info",
                            style: style2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                            label: "Total Maturity Amount",
                            data: totalMaturityAmount.toString()),
                      ),
                      Expanded(
                        child: customContainer(
                            label: "Total Maturity Interest",
                            data: totalMaturityInterestAmount.toString()),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                            label: "Total Pre-Maturity Charge",
                            data: totalPrematurityChargeAmount.toString()),
                      ),
                      Expanded(
                        child: customContainer(
                            label: "Total Collection Amount",
                            data: totalCoolectionAmount.toString()),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                            label: "Total Deposit Amount",
                            data: "$totalDeposit"),
                      ),
                      Expanded(
                        child: customContainer(
                            label: "Amount in Bank",
                            data:
                                "${totalCoolectionAmount - totalMaturityAmount}"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 30,
                        width: 300,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            "Loan Related Info",
                            style: style2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                            label: "Total Loan Sanctioned",
                            data: "${totalLoanSanctioned + closeLoanAmount}"),
                      ),
                      Expanded(
                        child: customContainer(
                            label: "Total loan Collection",
                            data: totalLoanCollected.toString()),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                            label: "Total Loan Repayment",
                            data: totalRepaymentAmount.toString()),
                      ),
                      Expanded(
                        child: customContainer(
                            label: "Loan Interest paid",
                            data: totalInterestPaid.toString()),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 30,
                        width: 300,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            "Expense Related Info",
                            style: style2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                          label: "Total Expense ",
                          data: totalExpenses.toString(),
                        ),
                      ),
                      Expanded(
                        child: customContainer(
                          label: "Salary Paid",
                          data: totalSalaries.toString(),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customContainer(
                          label: "Total Commission",
                          data: totalCommissionPaid.toString(),
                        ),
                      ),
                      Expanded(
                        child: customContainer(
                          label: "Total Service Charge",
                          data: loanServiceCharge.toString(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class customContainer extends StatelessWidget {
  final data;
  final label;
  const customContainer({Key? key, this.data, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.white, fontSize: 20);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.blue,
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toString(),
              style: style,
            ),
            Text(
              data + " /-" ?? "",
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
