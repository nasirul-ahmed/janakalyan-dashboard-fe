import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/models/loan_application_model.dart';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/screen/loan_application/loan_application.dart';
import 'package:janakalyan_admin/services/loan_application/loan_application_services.dart';
import 'package:janakalyan_admin/services/loan_services/loan_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:janakalyan_admin/utils/parse_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessApplication extends StatefulWidget {
  final bool type;
  final LoanApplicationModel loanApplication;
  const ProcessApplication(
      {Key? key, required this.type, required this.loanApplication})
      : super(key: key);

  @override
  State<ProcessApplication> createState() => _ProcessApplicationState();
}

class _ProcessApplicationState extends State<ProcessApplication> {
  final TextEditingController _input = TextEditingController();
  var selectedDate = DateTime.now();
  bool isLoading = false;
  String dropdownValue = "2";

  Future<Customer?> getcustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        '$janaklyan/api/admin/get-customer/${widget.loanApplication.depositAcNo}');
    //final url =Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        print(res.body);
        final parsed = jsonDecode(res.body);

        return Customer.fromJson(parsed[0]);
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> processApplication() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/process-application');
    var jsonBody = jsonEncode(<String, dynamic>{
      "id": widget.loanApplication.id,
      "amount": int.parse(_input.text),
      "processDate": selectedDate.toString()
    });
    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print("success");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> processAndCreateLoanAc() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/create-loan-account');
    print(dropdownValue);
    DateTime now = DateTime.now(); 
    DateTime afterThirty = now.add(const Duration(days: 30)); 

    var jsonBody = jsonEncode(<String, dynamic>{
      "id": widget.loanApplication.id,
      "depositAcNo": widget.loanApplication.depositAcNo,
      "custName": widget.loanApplication.custName,
      "collectorId": widget.loanApplication.collectorId,
      "createdAt": now.toString(),
      "loanAmount": widget.loanApplication.loanAmount,
      "interestRate": double.parse(dropdownValue),
      "dueDate":afterThirty.toString(),
    });
    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print("success");
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const LoanApplication()));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size2 = MediaQuery.of(context).size;
    var style = const TextStyle(color: Colors.white, fontSize: 16);
    var style2 = const TextStyle(
        color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type ? "Process Aplication" : "Accept Application"),
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: [
            Center(
              child: Card(
                elevation: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: size2.height * .8,
                  width: size2.width * .7,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            alignment: Alignment.topCenter,
                            width: size2.width * 0.65,
                            height: 60,
                            child: Center(
                              child: Text(
                                widget.type == true
                                    ? "Process Loan Application"
                                    : "Accept Loan Application",
                                style: style2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        container(size2, style, "Customer's Name",
                            widget.loanApplication.custName),
                        container(size2, style, "Applied Loan Amount",
                            widget.loanApplication.loanAmount),
                        container(size2, style, "Collector Code",
                            widget.loanApplication.collectorId),
                        container(size2, style, "Deposit Account No",
                            widget.loanApplication.depositAcNo),
                        widget.type
                            ? container(size2, style, "Proccessing Date",
                                formatDate(widget.loanApplication.processDate))
                            : Container(),
                        widget.type
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    "Select rate of Interest",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  DropdownButton<String>(
                                    //isExpanded: true,
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      '2',
                                      '2.5',
                                      '3',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            : Container(
                                width: size2.width * 0.59,
                                child: TextFormField(
                                  controller: _input,
                                  decoration: const InputDecoration(
                                    label: Text(
                                      "Enter a loan amount to be sanctioned",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.loanApplication.isSanctioned == 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      var picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2030));

                                      if (picked != null &&
                                          picked != selectedDate) {
                                        setState(() {
                                          selectedDate = picked;
                                        });
                                      }
                                      print(selectedDate.toString());
                                    },
                                    child: const Text(
                                      "Select a proccess date",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        var picked = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030));

                                        if (picked != null &&
                                            picked != selectedDate) {
                                          setState(() {
                                            selectedDate = picked;
                                          });
                                        }
                                        print(selectedDate.toString());
                                      },
                                      child: Text(formatDate(selectedDate),
                                          style: style))
                                ],
                              )
                            : SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              child: "Reject Application",
                              onTap: () {
                                //do something
                                LoanServices x = LoanServices();

                                x.deleteApplication(
                                    widget.loanApplication.id ?? 0);
                              },
                            ),
                            CustomButton(
                              child: widget.type
                                  ? "Create Loan"
                                  : "Accept Application",
                              onTap: () async {
                                // if (widget.type) {
                                //   await processAndCreateLoanAc();
                                // } else {
                                //   await processApplication();
                                // }
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: widget.type
                                      ? 'Do you want to process the Loan Application?'
                                      : "Creating new loan account!",
                                  desc:
                                      'For Deposit Account: ${widget.loanApplication.depositAcNo}',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    if (widget.type) {
                                      processAndCreateLoanAc();
                                    } else {
                                      processApplication();
                                    }
                                  },
                                )..show();
                              },
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    isLoading = !isLoading;
                  });
                  // /api/admin/get-customer/633
                  getcustomer();
                },
                child: const Text(
                  "Click here to see passbook",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
            ),
            isLoading == true
                ? FutureBuilder<Customer?>(
                    future: getcustomer(),
                    builder: (_, snap) {
                      if (snap.hasError) {
                        return const Center(
                          child: Text("Error"),
                        );
                      } else if (snap.hasData) {
                        var cust = snap.data;
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              container(size2, style, "Account Number",
                                  cust!.accountNumber),
                              container(size2, style, "Name", cust.name),
                              container(size2, style, "Installment",
                                  cust.installmentAmount),
                              container(size2, style, "Principam Amount",
                                  cust.totalPrincipalAmount),
                              container(size2, style, "Maturity Amount",
                                  cust.totalMaturityAmount),
                              container(size2, style, "Collection",
                                  cust.totalCollection),
                              container(size2, style, "Account Opening Date",
                                  formatDate(cust.createdAt)),
                              container(size2, style, "Maturity Date",
                                  formatDate(cust.maturityDate)),
                              SizedBox(height: 50),
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                    })
                : Container()
          ],
        ),
      ),
    );
  }

  Widget container(dynamic size2, TextStyle style, String label, dynamic data) {
    return Card(
      child: Container(
        alignment: Alignment.topCenter,
        width: size2.width * 0.6,
        height: 50,
        color: Colors.blueGrey[400],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: style,
                ),
                Text(
                  "$data",
                  style: style,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String child;
  final TaskCallback onTap;
  final Color? color;
  const CustomButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      hoverColor: Colors.blueGrey,
      color: color ?? Colors.red,
      height: 50,
      onPressed: () => onTap(),
      child: Text(
        child,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
