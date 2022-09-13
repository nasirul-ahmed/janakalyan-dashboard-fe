import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ClosingStatement extends StatelessWidget {
  ClosingStatement({Key? key, required this.maturity}) : super(key: key);
  final Maturity maturity;

  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1.6);
    var screen = MediaQuery.of(context).size;
    handleClick() async {
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
                      maturity.isPreMaturity == 0
                          ? "Maturity - Closing Statement"
                          : "Pre Maturity - Closing Statement ",
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
                        pw.Text(maturity.custName.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Father Name"),
                        pw.Text(maturity.fathersName.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Address"),
                        pw.Text(maturity.address.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Account Number"),
                        pw.Text(maturity.accountNumber.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Collector Code"),
                        pw.Text(maturity.collectorId.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("A/c Opening Date"),
                        pw.Text(formatDate(maturity.openingDate)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Submission Date"),
                        pw.Text(formatDate(maturity.submitDate)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Processing Date"),
                        pw.Text(formatDate(maturity.processDate)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Maturity Value (Rs)"),
                        pw.Text(maturity.maturityValue.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Maturity / Deposit Amount (Rs)"),
                        pw.Text(maturity.maturityAmount.toString()),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    maturity.isPreMaturity == 0
                        ? pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Maturity Intrest Amount (Rs)"),
                              pw.Text(
                                  "+  " + maturity.maturityInterest.toString()),
                            ],
                          )
                        : pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text("Pre Maturity Charge (Rs)"),
                              pw.Text("-  " +
                                  maturity.preMaturityCharge.toString()),
                            ],
                          ),
                    pw.SizedBox(height: 5),
                    pw.Divider(),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Net Payable Amount (Rs)"),
                        pw.Text(
                            "=  " + maturity.totalAmount.toString() + " /-"),
                      ],
                    ),
                    pw.Divider(),
                    pw.SizedBox(
                      height: 20,
                    ),
                    pw.Text(
                        "I've recieved the amount as mentioned above in full as per Samittees Scheme deposited by me and I've no claim against the Society and to the Account."),
                    pw.SizedBox(
                      height: 40,
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Collector (signature)"),
                          pw.Text("Account Holder (Signature/Thumb)")
                        ]),
                    pw.Divider(),
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
        ..download = 'closing_statement-${maturity.accountNumber}.pdf'
        ..click();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Maturity Closing Statement"), actions: [
        ElevatedButton(
          onPressed: handleClick,
          child: Icon(Icons.print, color: Colors.white),
        )
      ]),
      body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Card(
                elevation: 16,
                child: Container(
                  height: 50,
                  width: screen.width * 0.5,
                  color: maturity.isPreMaturity == 0 ? Colors.blue : Colors.red,
                  child: Center(
                    child: Text(
                      maturity.isPreMaturity == 0 ? "Maturity" : "Pre-Maturity",
                      style: style,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Container(
                width: screen.width * 0.4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRows(
                          label: "Name", data: maturity.custName.toString()),
                      CustomRows(
                          label: "Father's Name",
                          data: maturity.fathersName.toString()),
                      CustomRows(
                          label: "Address", data: maturity.address.toString()),
                      CustomRows(
                          label: "Account No.",
                          data: maturity.accountNumber.toString()),
                      CustomRows(
                          label: "Collector Code",
                          data: maturity.collectorId.toString()),
                      CustomRows(
                          label: "Account opening Date",
                          data: formatDate(maturity.openingDate)),
                      CustomRows(
                          label: "M. Submit Date",
                          data: formatDate(maturity.submitDate)),
                      //
                      //
                      //
                      CustomRows(
                          label: "M. Processing Date",
                          data: formatDate(maturity.processDate)),
                      CustomRows(
                          label: "Maturity Value (Rs)",
                          data: maturity.maturityValue.toString() + "/-"),
                      CustomRows(
                          label: "Deposit Amount (Rs)",
                          data: maturity.maturityAmount.toString() + "/-"),
                      //
                      //
                      CustomRows(
                          label: "Maturity Interest (Rs)",
                          data: maturity.maturityInterest.toString() + "/-"),
                      CustomRows(
                          label: "Pre Maturity Charge (Rs)",
                          data: maturity.preMaturityCharge.toString() + "/-"),
                      //
                      CustomRows(
                          label: "Net Payable Amount (Rs)",
                          data: (maturity.totalAmount).toString() + "/-"),

                      const SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: InkWell(
                          onTap: handleClick,
                          child: Container(
                            height: 40,
                            width: 400,
                            child: const Center(
                              child: Text("Download Closing Statement"),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            )
          ]),
    );
  }
}

class Details {
  final String name;
  final String value;
  Details({required this.name, required this.value});
}

class CustomRows extends StatelessWidget {
  final String label;
  final String data;
  const CustomRows({Key? key, required this.label, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black, fontSize: 16);
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style,
          ),
          Text(
            data,
            style: style,
          ),
        ],
      ),
    );
  }
}
