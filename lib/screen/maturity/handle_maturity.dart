// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:janakalyan_admin/screen/maturity/maturity_list.dart';
import 'package:janakalyan_admin/screen/passbook/deposit_passbook.dart';
import 'package:janakalyan_admin/services/maturity/maturity.services.dart';
import 'package:janakalyan_admin/services/passbook_services/passbook_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class HandleMaturity extends StatefulWidget {
  final Maturity maturity;
  final bool isMatured;
  HandleMaturity({Key? key, required this.maturity, required this.isMatured})
      : super(key: key);

  @override
  State<HandleMaturity> createState() => _HandleMaturityState();
}

class _HandleMaturityState extends State<HandleMaturity> {
  TextEditingController amount = TextEditingController();

  MaturityServices maturityServices = MaturityServices();

  PassbookServices passbookServices = PassbookServices();
  late Customer customer;
  Future getPassBook() async {
    customer =
        await passbookServices.getCustomerByAc(widget.maturity.accountNumber);
  }

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
                    widget.maturity.isPreMaturity == 0
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
                      pw.Text(widget.maturity.custName.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Father Name"),
                      pw.Text(widget.maturity.fathersName.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Address"),
                      pw.Text(widget.maturity.address.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Account Number"),
                      pw.Text(widget.maturity.accountNumber.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Collector Code"),
                      pw.Text(widget.maturity.collectorId.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("A/c Opening Date"),
                      pw.Text(formatDate(widget.maturity.openingDate)),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Submission Date"),
                      pw.Text(formatDate(widget.maturity.submitDate)),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Processing Date"),
                      pw.Text(formatDate(widget.maturity.processDate)),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Maturity Value (Rs)"),
                      pw.Text(widget.maturity.maturityValue.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Maturity / Deposit Amount (Rs)"),
                      pw.Text(widget.maturity.maturityAmount.toString()),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  widget.maturity.isPreMaturity == 0
                      ? pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Maturity Intrest Amount (Rs)"),
                            pw.Text("+  " +
                                widget.maturity.maturityInterest.toString()),
                          ],
                        )
                      : pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Pre Maturity Charge (Rs)"),
                            pw.Text("-  " +
                                widget.maturity.preMaturityCharge.toString()),
                          ],
                        ),
                  pw.SizedBox(height: 5),
                  pw.Divider(),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Net Payable Amount (Rs)"),
                      pw.Text("=  " +
                          widget.maturity.totalAmount.toString() +
                          " /-"),
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
      ..download = 'closing_statement-${widget.maturity.accountNumber}.pdf'
      ..click();
  }

  @override
  void initState() {
    super.initState();
    getPassBook();
  }

  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1.6);
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: handleClick,
              child: Icon(
                Icons.print,
                semanticLabel: "Print",
                size: 30,
                color: Colors.white,
              ),
            ),
          )
        ],
        title: Text(
            widget.isMatured ? "Maturity Submission" : "Maturity Processing"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Card(
                    elevation: 16,
                    child: Container(
                      height: 50,
                      width: screen.width * 0.8,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          widget.maturity.isPreMaturity == 0
                              ? "Maturity"
                              : "Pre-Maturity",
                          style: style,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  child: Container(
                    width: screen.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomRows(
                            label: "Name",
                            data: widget.maturity.custName.toString()),
                        CustomRows(
                            label: "Father's Name",
                            data: widget.maturity.fathersName.toString()),
                        CustomRows(
                            label: "Address",
                            data: widget.maturity.address.toString()),
                        CustomRows(
                            label: "Account No.",
                            data: widget.maturity.accountNumber.toString()),
                        CustomRows(
                            label: "Collector Code",
                            data: widget.maturity.collectorId.toString()),
                        CustomRows(
                            label: "Account opening Date",
                            data: formatDate(widget.maturity.openingDate)),
                        CustomRows(
                            label: "M. Submit Date",
                            data: formatDate(widget.maturity.submitDate)),
                        //
                        //
                        //
                        widget.isMatured
                            ? CustomRows(
                                label: "M. Processing Date",
                                data: formatDate(widget.maturity.processDate))
                            : const SizedBox(),
                        CustomRows(
                            label: "Maturity Value (Rs)",
                            data: widget.maturity.maturityValue.toString() +
                                "/-"),
                        CustomRows(
                            label: "Deposit Amount (Rs)",
                            data: widget.maturity.maturityAmount.toString() +
                                "/-"),
                        //
                        //
                        widget.maturity.isPreMaturity == 0
                            ? CustomRows(
                                label: "Maturity Interest (Rs)",
                                data: widget.maturity.maturityInterest
                                        .toString() +
                                    "/-")
                            : CustomRows(
                                label: "Pre Maturity Charge (Rs)",
                                data: widget.maturity.preMaturityCharge
                                        .toString() +
                                    "/-"),
                        //
                        widget.maturity.isPreMaturity == 0
                            ? CustomRows(
                                label: "Net Payable Amount (Rs)",
                                data:
                                    (widget.maturity.totalAmount!).toString() +
                                        "/-")
                            : CustomRows(
                                label: "Net Payable Amount (Rs)",
                                data: (widget.maturity.totalAmount).toString() +
                                    "/-"),
                        //
                        widget.isMatured
                            ? CustomRows(
                                label: "Loss (Rs)",
                                data: widget.maturity.loss.toString() + "/-")
                            : const SizedBox(),

                        // deposit amount
                        // pre maturity charge
                        // maturity interest

                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          child: InkWell(
                            onTap: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.BOTTOMSLIDE,
                                title:
                                    'Maturing A/c ${widget.maturity.accountNumber}?',
                                desc:
                                    'Total Amount : ${widget.maturity.totalAmount} /-',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () async {
                                  await maturityServices
                                      .matureSuccessfully(widget.maturity);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => MaturityList()));
                                },
                              )..show();
                            },
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width * .5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  !widget.isMatured
                                      ? "Process Maturity"
                                      : "Mature this Account",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          child: InkWell(
                            onTap: handleClick,
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width * .5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(
                                  "Print Statement",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        DepositPassbook(doc: customer)))
                          },
                          child: Container(
                            width: screen.width * 0.5,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text(
                                "See Passbook",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
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
      width: MediaQuery.of(context).size.width * 0.5,
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
