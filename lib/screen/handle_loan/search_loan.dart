import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_customer.dart';
import 'package:janakalyan_admin/screen/handle_loan/loan_repayment.dart';
import 'package:janakalyan_admin/screen/handle_loan/repayment_history.dart';
import 'package:janakalyan_admin/screen/passbook/loan_passbook.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:janakalyan_admin/utils/isNumber.dart';
import 'package:janakalyan_admin/widgets/account_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

class SearchLoan extends StatefulWidget {
  SearchLoan({Key? key}) : super(key: key);

  @override
  State<SearchLoan> createState() => _SearchLoanState();
}

class _SearchLoanState extends State<SearchLoan> {
  TextEditingController controller = TextEditingController();
  bool isSelected = false;
  late LoanCustomer _customer;

  var count = 0;
  String query = '';

  bool isFilter = false;
  DateTime selectedDate = DateTime.now();

  Future<List<LoanCustomer>> getLoanCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/all-loan-ac');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<LoanCustomer> list = parsed
            .map<LoanCustomer>((json) => LoanCustomer.fromJson(json))
            .toList();
        int c = list.length;
        // setState(() {
        count = c;

        return list;
      }
      return List<LoanCustomer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<LoanCustomer>> getLoanCustomerByAc() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = isNumeric(query)
        ? Uri.parse('$janaklyan/api/admin/loan-by-ac')
        : Uri.parse('$janaklyan/api/admin/loan-by-name');
    //final url = Uri.parse("uri");
    try {
      var res = await http.post(url,
          body: jsonEncode(
              <String, dynamic>{"searched": query}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<LoanCustomer> list = parsed
            .map<LoanCustomer>((json) => LoanCustomer.fromJson(json))
            .toList();
        int c = list.length;
        // setState(() {
        count = c;

        return list;
      }
      return List<LoanCustomer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<LoanCustomer>> getLoanCustomerByDueDate() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        '$janaklyan/api/admin/loan-by-due/${selectedDate.toString().split(" ")[0]}');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<LoanCustomer> list = parsed
            .map<LoanCustomer>((json) => LoanCustomer.fromJson(json))
            .toList();
        int c = list.length;
        count = c;

        return list;
      }
      return List<LoanCustomer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future closeLoan() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/close-loan');
    //final url = Uri.parse("uri");
    try {
      var res = await http.post(url,
          body: jsonEncode(<String, dynamic>{
            "loanAc": _customer.loanAcNo,
            "accountNumber": _customer.depositAcNo
          }),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });
      if (200 == res.statusCode) {
        print(res.body);
      }
      //return List<LoanCustomer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        query = controller.text;
      });
    });
    call();
  }

  void call() async {
    List<LoanCustomer> l = await getLoanCustomer();

    if (mounted) {
      setState(() {
        count = l.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Loan Customers"),
      ),
      body: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blueGrey,
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              children: [
                searchbox(
                  email: controller,
                  count: count,
                ),

                //SearchLoanByAc(ac: email, label: label)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter",
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _selectDate(context);
                              setState(() {
                                isFilter = true;
                              });
                            },
                            child: Text(
                              formatDate(selectedDate),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isFilter = false;
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // selectedDate.day == DateTime.now().day
                !isFilter
                    ? Expanded(
                        child: FutureBuilder<List<LoanCustomer>>(
                          future: query.isEmpty
                              ? getLoanCustomer()
                              : getLoanCustomerByAc(),
                          builder: (context, snap) {
                            if (snap.hasError) {
                              return const CircularProgressIndicator.adaptive();
                            } else if (snap.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data?.length,
                                  itemBuilder: (context, id) {
                                    return customListTile(
                                      snap.data![id],
                                      function: () {
                                        if (mounted) {
                                          setState(() {
                                            isSelected = true;
                                            _customer = snap.data![id];
                                          });
                                        }
                                      },
                                    );
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                          },
                        ),
                      )
                    : Expanded(
                        child: FutureBuilder<List<LoanCustomer>>(
                          future: getLoanCustomerByDueDate(),
                          builder: (context, snap) {
                            if (snap.hasError) {
                              return const CircularProgressIndicator.adaptive();
                            } else if (snap.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snap.data?.length,
                                  itemBuilder: (context, id) {
                                    return customListTile(
                                      snap.data![id],
                                      function: () {
                                        if (mounted) {
                                          setState(() {
                                            isSelected = true;
                                            _customer = snap.data![id];
                                          });
                                        }
                                      },
                                    );
                                  });
                            } else {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                          },
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          isSelected
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Column(
                      children: [
                        CustomButton(
                            callback: () {},
                            title: "Loan Account Number ${_customer.loanAcNo}"),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LoanPassbook(doc: _customer),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.60,
                            color: Colors.blue,
                            child: const Center(
                              child: Text("Loan Passbook",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            callback: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoanRepaymentPage(
                                            customer: _customer,
                                          )));
                            },
                            title: "Make Repayment"),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                            callback: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RepaymentHistory(
                                    customer: _customer,
                                  ),
                                ),
                              );
                            },
                            title: "Repayment History"),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              // Close the account here

                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2),
                                width: 380,
                                buttonsBorderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                headerAnimationLoop: false,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Loan A/c ${_customer.loanAcNo}',
                                desc: 'Closing Account',
                                showCloseIcon: true,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  closeLoan();
                                  Timer(
                                      const Duration(seconds: 3),
                                      () => {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        SearchLoan()))
                                          });
                                },
                              )..show();

                              //closeLoan();
                            },
                            child: Container(
                              //alignment: Alignment.topCenter,
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.60,
                              color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Close this Account ${_customer.loanAcNo}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  alignment: Alignment.centerRight,
                  child: const Center(
                    child: Text("Please select an account"),
                  ),
                )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.callback, required this.title})
      : super(key: key);
  final VoidCallback callback;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        alignment: Alignment.topCenter,
        height: 80,
        width: MediaQuery.of(context).size.width * 0.69,
        color: Colors.amber,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class customListTile extends StatefulWidget {
  final LoanCustomer customer;

  final Function function;

  customListTile(this.customer, {Key? key, required this.function})
      : super(key: key);

  @override
  State<customListTile> createState() => _customListTileState();
}

class _customListTileState extends State<customListTile> {
  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(color: Colors.white);
    var style2 = const TextStyle(color: Colors.white);
    var style3 = const TextStyle(color: Colors.white);
    return Container(
      child: ListTile(
        onTap: () {
          widget.function();
        },
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Next Due Date: ${formatDate(widget.customer.dueDate)}",
                style: style),
            const SizedBox(
              height: 5,
            ),
            Text(
              "L. Collection (RS): ${widget.customer.totalCollection}/-",
              style: style,
            ),
          ],
        ),
        title: Row(
          children: [
            Text(
              "${widget.customer.custName}",
              style: style,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "(A/c: ${widget.customer.loanAcNo})",
              style: style,
            ),
          ],
        ),
        subtitle: Text(
          "Rem. Loan(Rs): ${widget.customer.remLoanAmnt}/-",
          style: const TextStyle(color: Colors.amberAccent),
        ),
        leading: Container(
          width: 40,
          height: 40,
          //child: Image.memory(profile),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
