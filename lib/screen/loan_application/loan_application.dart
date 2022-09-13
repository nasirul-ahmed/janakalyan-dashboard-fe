import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/loan_application_model.dart';
import 'package:janakalyan_admin/screen/loan_application/process_application.dart';
import 'package:janakalyan_admin/services/loan_services/loan_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanApplication extends StatefulWidget {
  const LoanApplication({Key? key}) : super(key: key);

  @override
  State<LoanApplication> createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplication> {
  num count = 0;
  num count2 = 0;

  List<LoanApplicationModel> pendings = List.empty();
  List<LoanApplicationModel> processed = List.empty();

  LoanServices loanServices = LoanServices();

  // Future<List<LoanApplicationModel>> pendingLoanApplication() async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   final url = Uri.parse('$janaklyan/api/admin/loan-application');
  //   try {
  //     var res = await http.get(url, headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "*/*",
  //       "Authorization": "Bearer ${_prefs.getString('token')}"
  //     });
  //     if (200 == res.statusCode) {
  //       final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

  //       List<LoanApplicationModel> list = parsed
  //           .map<LoanApplicationModel>(
  //               (json) => LoanApplicationModel.fromJson(json))
  //           .toList();

  //           count = list.length;

  //       // setState(() {
  //       //   count = list.length;
  //       // });
  //       return list;
  //     }
  //     return List<LoanApplicationModel>.empty();
  //   } catch (e) {
  //     print(e);
  //     throw e;
  //   }
  // }

  // Future<List<LoanApplicationModel>> processLoanApplication() async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   final url = Uri.parse('$janaklyan/api/admin/approved-loan-application');
  //   //final url = Uri.parse("uri");
  //   try {
  //     var res = await http.get(url, headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "*/*",
  //       "Authorization": "Bearer ${_prefs.getString('token')}"
  //     });
  //     if (200 == res.statusCode) {
  //       final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

  //       List<LoanApplicationModel> list = parsed
  //           .map<LoanApplicationModel>(
  //               (json) => LoanApplicationModel.fromJson(json))
  //           .toList();
  //       // setState(() {
  //       //   count2 = list.length;
  //       // });
  //       count2 = list.length;
  //       return list;
  //     }
  //     return List<LoanApplicationModel>.empty();
  //   } catch (e) {
  //     print(e);
  //     throw e;
  //   }
  // }

//   void getData() async{
//     List<LoanApplicationModel> l = await pendingLoanApplication();
//     List<LoanApplicationModel> l2 = await processLoanApplication();
// List<LoanApplicationModel> pendings = _loanServices.pendingLoanApplication;
//     List<LoanApplicationModel> approved = _loanServices.pendingLoanApplication();
//     //print(l.length);
//     // setState(() {
//     //   count = l.length;
//     //   count2 = l2.length;
//     // });

//   }

  void getCounts() async {
    await loanServices.countLoans();

    setState(() {
      count = loanServices.getPendings;
      count2 = loanServices.getApproved;
    });
  }

  @override
  void initState() {
    super.initState();

    getCounts();
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Application"),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: Colors.blueGrey[600],
                    child: Center(
                      child: Text("Pending Loan Application ($count)",
                          style: style),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.45,
                    color: Colors.blueGrey[600],
                    child: Center(
                      child: Text(
                        "Proccessing Loan Application ($count2)",
                        style: style,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            //shrinkWrap: true,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomLoanApplication(
                  callback: loanServices.pendingLoanApplication,
                ),
              ),
              Expanded(
                child: CustomLoanApplication(
                  callback: loanServices.processLoanApplication,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomLoanApplication extends StatelessWidget {
  final TaskCallback callback;
  const CustomLoanApplication({Key? key, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LoanApplicationModel>>(
      future: callback(),
      builder: (_, snap) {
        if (snap.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snap.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snap.data!.length,
              itemBuilder: (_, id) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: snap.data![id].isSanctioned != 1
                        ? Text(
                            "${snap.data![id].custName} (C.code: ${snap.data![id].collectorId.toString()})")
                        : Text(
                            "${snap.data![id].custName} (A/C: ${snap.data![id].depositAcNo}) (C.code: ${snap.data![id].collectorId})"),
                    subtitle: snap.data![id].isSanctioned != 1
                        ? Text("A/C: ${snap.data![id].depositAcNo}")
                        : Text(
                            "Sanction Date: ${formatDate(snap.data![id].processDate)}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Applied Loan Amnt: ${snap.data![id].loanAmount}"),
                        Text(
                            "Applied Date: ${formatDate(snap.data![id].createdAt)} "),
                      ],
                    ),
                    onTap: () {
                      if (snap.data![id].isSanctioned == 0) {
                      } else {

                        
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProcessApplication(
                            type:
                                snap.data![id].isSanctioned == 1 ? true : false,
                            loanApplication: snap.data![id],
                          ),
                        ),
                      );
                    },
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
