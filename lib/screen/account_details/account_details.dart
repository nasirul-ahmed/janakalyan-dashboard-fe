import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/models/loan_customer.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:janakalyan_admin/screen/account_details/closing_statement.dart';
import 'package:janakalyan_admin/screen/account_register/account_register.dart';
import 'package:janakalyan_admin/screen/edit_customer.js/edit_customer.dart';
import 'package:janakalyan_admin/screen/passbook/deposit_passbook.dart';
import 'package:janakalyan_admin/screen/passbook/loan_passbook.dart';
import 'package:janakalyan_admin/services/hold_account/hold_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDetailsPage extends StatefulWidget {
  final Customer customer;
  AccountDetailsPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  HoldAccount hold = HoldAccount();

  bool isCorrectCollectionClicked = false;
  bool isLoading = false;
  TextEditingController amount = TextEditingController();
  TextEditingController collectionId = TextEditingController();

  late Maturity maturity;

  Future<LoanCustomer> getLoanCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/loan-by-ac');
    try {
      var res = await http.post(url,
          body: jsonEncode(
              <String, dynamic>{"searched": widget.customer.loanAccountNumber}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        return LoanCustomer.fromJson(parsed[0]);
      }
      throw Exception();
    } catch (e) {
      rethrow;
    }
  }

  Future<LoanCustomer> correctCollection() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/correct-collection');

    var body = jsonEncode(<String, dynamic>{
      "collectionId": collectionId.text,
      "amount": amount.text,
    });

    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed);
        return LoanCustomer.fromJson(parsed[0]);
      }
      throw Exception();
    } catch (e) {
      rethrow;
    }
  }

  Future<Maturity> getClosingStatement() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        '$janaklyan/api/admin/get-maturity-by-ac/${widget.customer.accountNumber}');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        return Maturity.fromJson(parsed);
      }
      throw Exception();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Account Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.all(20),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 90,
                      child: InkWell(
                        child: Center(
                            child: Text(
                          "Account Number: ${widget.customer.accountNumber ?? ""}",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Options(
                      label: "Account Details",
                      callback: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AccountRegister(customer: widget.customer),
                          ),
                        );
                      },
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    Options(
                      label: "PassBook",
                      callback: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DepositPassbook(doc: widget.customer),
                          ),
                        );
                      },
                    ),
                    widget.customer.isActive == 3
                        ? Options(
                            label: "Closing Statement",
                            callback: () async {
                              setState(() {
                                isLoading = true;
                              });
                              maturity = await getClosingStatement();

                              Future.delayed(const Duration(seconds: 3));
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ClosingStatement(maturity: maturity),
                                ),
                              );
                            },
                          )
                        : const SizedBox(),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    widget.customer.loanAccountNumber != 0 &&
                            widget.customer.loanAccountNumber != null
                        ? Options(
                            label: "Loan PassBook",
                            callback: () async {
                              late LoanCustomer loancustomer;
                              loancustomer = await getLoanCustomer();
                              Future.delayed(const Duration(seconds: 3));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LoanPassbook(doc: loancustomer),
                                ),
                              );
                            },
                          )
                        : const SizedBox(),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    widget.customer.isActive != 1
                        ? const SizedBox()
                        : Options(
                            label: "Edit Account",
                            callback: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditCustomer(customer: widget.customer),
                                ),
                              );
                            },
                          ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    widget.customer.isActive == 5 ||
                            widget.customer.isActive == 3 ||
                            widget.customer.isActive == 2
                        ? const SizedBox()
                        : Options(
                            label: "Hold Account",
                            accountNo: widget.customer.accountNumber,
                            callback: () {
                              //hold.holdaccount(customer.accountNumber)
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.INFO,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Are you sure?',
                                desc:
                                    'holding account : ${widget.customer.accountNumber}',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () => hold
                                    .holdaccount(widget.customer.accountNumber),
                              )..show();
                            },
                          ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    isCorrectCollectionClicked
                        ? Container(
                            child: Column(
                              children: [
                                //"Enter the Correct Collection Amount"
                                CustomFields(
                                  controller: collectionId,
                                  label:
                                      "Enter the Transaction ID / Collection ID",
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomFields(
                                  controller: amount,
                                  label: "Enter the Correct Collection Amount",
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    widget.customer.isActive == 1
                        ? Options(
                            label: isCorrectCollectionClicked
                                ? "Correct Collection Now"
                                : "Correct Collection Section",
                            callback: () {
                              if (isCorrectCollectionClicked) {
                                setState(() {
                                  isLoading = true;
                                });

                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: 'Collection ID: ${collectionId.text}',
                                  desc: 'Correct amnt : ${amount.text}',
                                  btnCancelOnPress: () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  btnOkOnPress: () async {
                                    await correctCollection();
                                    Future.delayed(const Duration(seconds: 3));

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                )..show();
                              } else {
                                setState(() {
                                  isCorrectCollectionClicked = true;
                                });
                              }
                            },
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
      ),
    );
  }
}

class CustomFields extends StatelessWidget {
  const CustomFields({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorWidth: 2.0,
      style: const TextStyle(color: Colors.grey),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Required*';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.red),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, letterSpacing: 2),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.black, width: 2, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

class Options extends StatelessWidget {
  final String? label;
  final VoidCallback? callback;
  final int? accountNo;

  const Options({Key? key, required this.label, this.callback, this.accountNo})
      : super(key: key);
  final style = const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        callback!();
      },
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          width: screen.width * 0.7,
          height: 60.0,
          color: Colors.red,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "$label",
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}
