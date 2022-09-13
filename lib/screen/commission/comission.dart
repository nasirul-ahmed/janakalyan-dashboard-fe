import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Commission extends StatefulWidget {
  const Commission({Key? key, required this.collector}) : super(key: key);
  final int collector;

  @override
  _CommissionState createState() => _CommissionState();
}

class _CommissionState extends State<Commission> {
  PageController pageController =
      PageController(initialPage: DateTime.now().year);
  DateTime selectedDate = DateTime.now();
  int displayedYear = DateTime.now().year;
  num commission = 0;
  bool isLoanding = false;

  Future payCommission(commission) async {
    setState(() {
      isLoanding = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/pay-commission');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector,
      "commissionPaid": commission,
      "createdAt": DateTime.now().toString(),
      "paidMonth": selectedDate.toString()
    });
    print(commission);
    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        setState(() {
          isLoanding = false;
        });
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> getCommission(selectedDate) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/monthly-commission');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector,
      "createdAt": selectedDate.toString(),
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        num cm = parsed[0]["commission"] ?? 0;
        commission = cm;
        return cm;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> getAllTimeCommission(collectorId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url =
        Uri.parse('$janaklyan/api/admin/all-time-commission/$collectorId');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        num cm = parsed[0]["commission"] ?? 0;

        return cm;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<num?> thisMonthsDeposits() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse("$janaklyan/api/admin/monthly-deposits");
    //final url = Uri.parse("uri");

    var body = jsonEncode(<String, dynamic>{
      "collectorId": widget.collector,
      "createdAt": selectedDate.toString()
    });
    try {
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          },
          body: body);
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(res.body);
        return parsed[0]["deposits"] ?? 0;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pay Commission"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Center(
                              child: Text(
                                "All Time Commission",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 19),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder<num?>(
                                future: getAllTimeCommission(widget.collector),
                                builder: (_, snap) {
                                  if (snap.hasError) {
                                    return const Text("Error");
                                  } else if (snap.hasData) {
                                    return Text("${snap.data}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18));
                                  } else {
                                    return const CircularProgressIndicator
                                        .adaptive(
                                      backgroundColor: Colors.white,
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Center(
                              child: Text(
                                "Month's Collection",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 19),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder<num?>(
                                future: thisMonthsDeposits(),
                                builder: (_, snap) {
                                  if (snap.hasError) {
                                    return const Text("Error");
                                  } else if (snap.hasData) {
                                    return Text("${snap.data}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18));
                                  } else {
                                    return const CircularProgressIndicator
                                        .adaptive(backgroundColor: Colors.white);
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: yearMonthPicker(),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 215,
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              "Commission",
                              style: TextStyle(color: Colors.white, fontSize: 19),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<num?>(
                              future: getCommission(selectedDate),
                              builder: (_, snap) {
                                if (snap.hasError) {
                                  return const Text("Error");
                                } else if (snap.hasData) {
                                  return Text("${snap.data}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18));
                                } else {
                                  return const CircularProgressIndicator
                                      .adaptive();
                                }
                              })
                        ],
                      ),
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      borderSide: BorderSide(color: Colors.green, width: 2),
                      width: 380,
                      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                      headerAnimationLoop: false,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'Loan Repayment',
                      desc: 'Amount: $commission',
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await payCommission(commission);
                        if (isLoanding) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              });
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )..show();
                  },
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        "Pay Now",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  yearMonthPicker() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(builder: (context) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return IntrinsicWidth(
                child: Column(children: [
                  buildHeader(),
                  Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [buildPager()],
                    ),
                  )
                ]),
              );
            }
            return IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [buildPager()],
                      ),
                    )
                  ]),
            );
          }),
        ],
      );
  buildHeader() {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Selected Month & Year",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${DateFormat.yMMM().format(selectedDate)}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${DateFormat.y().format(DateTime(displayedYear))}',
                    style: TextStyle(color: Colors.white)),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildPager() => Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Theme(
          data: Theme.of(context).copyWith(
              buttonTheme: const ButtonThemeData(
                  padding: EdgeInsets.all(0.0),
                  shape: CircleBorder(),
                  minWidth: 1.0)),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                displayedYear = index;
              });
            },
            itemBuilder: (context, year) {
              return GridView.count(
                padding: EdgeInsets.all(12.0),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 6,
                children: List<int>.generate(12, (i) => i + 1)
                    .map((month) => DateTime(year, month))
                    .map(
                      (date) => Padding(
                        padding: EdgeInsets.all(4.0),
                        child: MaterialButton(
                          onPressed: () => setState(() {
                            selectedDate = DateTime(date.year, date.month);
                          }),
                          color: date.month == selectedDate.month &&
                                  date.year == selectedDate.year
                              ? Colors.orange
                              : null,
                          textColor: date.month == selectedDate.month &&
                                  date.year == selectedDate.year
                              ? Colors.white
                              : date.month == DateTime.now().month &&
                                      date.year == DateTime.now().year
                                  ? Colors.orange
                                  : null,
                          child: Text(
                            DateFormat.MMM().format(date),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      );
}
