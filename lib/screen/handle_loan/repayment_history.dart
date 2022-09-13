import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_customer.dart';
import 'package:janakalyan_admin/models/loan_repayment.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class RepaymentHistory extends StatelessWidget {
  final LoanCustomer customer;
  const RepaymentHistory({Key? key, required this.customer}) : super(key: key);

  Future<List<LoanRepayment>> repaymntHistory() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse(
        "$janaklyan/api/admin/get-loan-repayment/${customer.loanAcNo}");

    try {
      var res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}",
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
        // print(parsed);
        return parsed
            .map<LoanRepayment>((json) => LoanRepayment.fromJson(json))
            .toList();
      }

      return List<LoanRepayment>.empty();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repayment History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                height: 150,
                width: MediaQuery.of(context).size.width * .6,
                color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Name :  ${customer.custName}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Collection Amnt : ${customer.totalCollection}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account No :  ${customer.loanAcNo}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Deposit Ac :  ${customer.depositAcNo}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loan Sanctioned :  ${customer.loanAmount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Coming Due Date :  ${formatDate(customer.dueDate)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<List<LoanRepayment>>(
                future: repaymntHistory(),
                builder: (_, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text(
                        'Account Number :  ${snap.error}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snap.hasData) {
                    return Center(
                        child: renderDatatable(
                      snap.data,
                    ));
                  }
                  return Container(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  SingleChildScrollView renderDatatable(
    List<LoanRepayment>? list,
  ) {
    ScrollController x = ScrollController();
    const style = TextStyle(color: Colors.black, fontSize: 16);
    const style1 = TextStyle(color: Colors.black, fontSize: 16);
    handleClick(LoanRepayment doc) async {
      const style = pw.TextStyle(color: PdfColors.red, fontSize: 22);

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                // pw.Center(
                //   child: pw.Text("Header"),
                // ),
                pw.Partition(
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          "JANAKALYAN AGRICULTURE & RURAL DEV. SOCIETY",
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Bechimari :: Darrang (Assam)",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "P.O: Bechimari, PIN - 784514 ",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Regd No :: RS/DAR/247/G/20 - 2008",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold),
                        )
                      ]),
                ),
                pw.Divider(),

                pw.Container(
                  //width: MediaQuery.of(pw.Context context).size.width,
                  height: 40,
                  color: PdfColors.blue,
                  child: pw.Center(
                    child: pw.Text(
                      "Repayment Reciept",
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ),
                pw.SizedBox(height: 15),
                pw.Partition(
                  child: pw.Column(children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Customer Name"),
                        pw.Text(customer.custName.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Loan Acoount No"),
                        pw.Text(doc.loanAcNo.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Deposit Acoount No"),
                        pw.Text(customer.depositAcNo.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Collector Code"),
                        pw.Text(doc.collectorId.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("A/c Opening Date"),
                        pw.Text(formatDate(doc.accountCreatedAt)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Repayment Date"),
                        pw.Text(formatDate(doc.createdAt)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Due Date"),
                        pw.Text(formatDate(doc.dueDate)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Next Due Date"),
                        pw.Text(formatDate(customer.dueDate)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Collection Amount(Rs)"),
                        pw.Text(doc.collectionAmount.toString() + " /-"),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Loan Sanctioned (Rs)"),
                        pw.Text(customer.loanAmount.toString() + " /-"),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Loan Interest(Rs)"),
                        pw.Text(doc.loanInterest.toString() + " /-"),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Loan Interest Paid(Rs)"),
                        pw.Text(doc.interestPaid.toString() + " /-"),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Repayment Amount (Rs)"),
                        pw.Text(doc.repaymentAmount.toString() + " /-"),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Total Paid Amount(Rs)"),
                        pw.Text("-" + doc.totalPaidAmount.toString() + " /="),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Divider(),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Remaining Loan Amount(Rs)"),
                        pw.Text("= " + doc.remLoanAmnt.toString() + " /="),
                      ],
                    ),
                    pw.SizedBox(
                      height: 40,
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Date:....................."),
                          pw.Text("Manager (Signature)")
                        ]),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Text("*Remarks",
                        style: const pw.TextStyle(
                          decoration: pw.TextDecoration.underline,
                        ))
                  ]),
                ),
              ],
            ); // Center
          },
        ),
      );
      Uint8List pdfInBytes = await pdf.save();

      final blob = html.Blob([pdfInBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'repayment-loanac-${doc.loanAcNo}.pdf'
        ..click();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        controller: x,
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: [
              DataColumn(label: Text('C.Id', style: style1)),
              DataColumn(label: Text('Date', style: style1)),
              DataColumn(label: Text('Collection', style: style1)),
              DataColumn(label: Text('Insrt. paid.', style: style1)),
              DataColumn(label: Text('Repaymnt. Amnt', style: style1)),
              DataColumn(label: Text('Total paid.', style: style1)),
              DataColumn(label: Text('Remaning. Loan', style: style1)),
            ],
            rows: list!
                .map((LoanRepayment doc) => DataRow(cells: [
                      DataCell(
                        Text(
                          '${doc.id}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                      DataCell(
                        Text(
                          '${formatDate(doc.createdAt)}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                      DataCell(
                        Text(
                          '${doc.collectionAmount}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                      DataCell(
                        Text(
                          '${doc.interestPaid}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                      DataCell(
                        Text(
                          '${doc.repaymentAmount}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                      DataCell(
                        Text(
                          '${doc.totalPaidAmount}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                      DataCell(
                        Text(
                          '${doc.remLoanAmnt}',
                          style: style,
                        ),
                        onTap: () {
                          handleClick(doc);
                        },
                      ),
                    ]))
                .toList()),
      ),
    );
  }
}
