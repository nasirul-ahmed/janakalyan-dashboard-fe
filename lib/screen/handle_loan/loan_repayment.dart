import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_customer.dart';
import 'package:janakalyan_admin/models/loan_repayment.dart';
import 'package:janakalyan_admin/screen/handle_loan/search_loan.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanRepaymentPage extends StatefulWidget {
  final LoanCustomer customer;
  LoanRepaymentPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<LoanRepaymentPage> createState() => _LoanRepaymentPageState();
}

class _LoanRepaymentPageState extends State<LoanRepaymentPage> {
  TextEditingController interest = TextEditingController();
  TextEditingController loanRepayment = TextEditingController();

  int interestPaid = 0;
  int loanRepAmnt = 0;

  bool isClicked = false;

  Future<List<LoanRepayment>> repaymntHistory() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse(
        "$janaklyan/api/admin/get-loan-repayment/${widget.customer.loanAcNo}");

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

  Future<void> makePayment() async {
    var date = DateTime.parse(widget.customer.updatedAt ?? "");
    var date2 = DateTime.now().difference(date).inDays;

    var loanInterest =
        ((widget.customer.interestRate! * widget.customer.remLoanAmnt!) /
                    30 /
                    100) *
                date2 +
            widget.customer.loanInterest!;

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/loan-repayment');
    var body = jsonEncode(<String, dynamic>{
      "loanAcNo": widget.customer.loanAcNo,
      "repaymentAmount": int.parse(loanRepayment.text),
      "createdAt": DateTime.now().toString().split(' ')[0],
      "loanInterest": loanInterest,
      "interestPaid": int.parse(interest.text),
      "dueDatex": widget.customer.dueDate,
      "nextDueDate": DateTime.now().add(const Duration(days: 30)).toString(),
    });
    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        debugPrint(parsed);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    interest.addListener(() {
      setState(() {
        interestPaid = interest.text.isEmpty ? 0 : int.parse(interest.text);
      });
    });
    loanRepayment.addListener(() {
      setState(() {
        loanRepAmnt =
            loanRepayment.text.isEmpty ? 0 : int.parse(loanRepayment.text);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    interest.dispose();
    loanRepayment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(widget.customer.updatedAt ?? "");
    var date2 = DateTime.now().difference(date).inDays;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Repayment"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  // shrinkWrap: true,
                  children: [
                    CustomDetails(
                        label: "Name",
                        data: widget.customer.custName.toString()),
                    CustomDetails(
                        label: "Loan Account Number",
                        data: widget.customer.loanAcNo.toString()),

                    InkWell(
                        onTap: () {
                          //Passbook
                        },
                        child: CustomDetails(
                            label: "Deposit Account Number",
                            data: widget.customer.depositAcNo.toString())),
                    CustomDetails(
                        label: "CollectorId",
                        data: widget.customer.collectorId.toString()),
                    CustomDetails(
                        label: "Loan Amount Sanctioned",
                        data: widget.customer.loanAmount.toString()),
                    CustomDetails(
                        label: "Rate %",
                        data: widget.customer.interestRate.toString()),
                    CustomDetails(
                        label: "Opening ",
                        data: formatDate(widget.customer.createdAt)),

                    CustomDetails(
                        label: "Last Repemnt. Date",
                        data: formatDate(widget.customer.updatedAt)),
                    CustomDetails(
                      label: "Due Date",
                      data: formatDate(widget.customer.dueDate),
                    ),
                    CustomDetails(
                        label: "Remaing Loan ",
                        data: widget.customer.remLoanAmnt.toString()),

                    CustomDetails(
                        label: "Loan Collected ",
                        data: widget.customer.totalCollection.toString()),
                    CustomDetails(
                        label: "Loan Interest ",
                        data:
                            " ${((widget.customer.interestRate! * widget.customer.remLoanAmnt!) / 30 / 100) * date2 + widget.customer.loanInterest! + ((widget.customer.loanInterest! * widget.customer.interestRate!) / 100)}"),

                    const SizedBox(
                      height: 10,
                    ),

                    // CustomDetails(
                    //     label: "Interest Amount",
                    //     data: "${int.parse(interest.text)}"),
                    // CustomDetails(
                    //     label: "Repayment Amount",
                    //     data: "${int.parse(loanRepayment.text)}"),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(children: [
                InputField(x: interest, label: "Enter interest Amount"),
                InputField(x: loanRepayment, label: "Repayment Amount"),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Interest"),
                      Text("+" + interestPaid.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Repayment"),
                      Text("+" + loanRepAmnt.toString()),
                    ],
                  ),
                ),
                CustomDetails(
                    label: "Interest + Loan Repayment",
                    data: "Total  = ${interestPaid + loanRepAmnt}/-"),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.INFO,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Making repayment?',
                        desc:
                            'Total amnt : ${int.parse(interest.text) + int.parse(loanRepayment.text)}',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          makePayment();
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(builder: (_) => SearchLoan()),
                          //     (route) => false);

                          Navigator.pop(context);
                        },
                      )..show();
                    },
                    child: const Center(
                      child: Text(
                        "Make Payment",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                !isClicked
                    ? InkWell(
                        child: const Center(
                          child: Text("Repayment History"),
                        ),
                      )
                    : FutureBuilder<List<LoanRepayment>>(
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
                              child: SizedBox(),

                              // renderDatatable(
                              //   snap.data,
                              // ),
                            );
                          }
                          return Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        })
              ]),
            )),
          ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController x;
  final String label;
  const InputField({Key? key, required this.x, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: TextFormField(
          cursorWidth: 2.0,
          style: const TextStyle(color: Colors.black),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Required*';
            }
            return null;
          },
          controller: x,
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.white),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey, letterSpacing: 3),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDetails extends StatelessWidget {
  final String label;
  final String data;
  const CustomDetails({Key? key, required this.label, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      color: Colors.blue,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              data,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
