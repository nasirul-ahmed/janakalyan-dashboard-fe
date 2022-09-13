import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/collector_model.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:janakalyan_admin/widgets/loading_dialog.dart';
import 'package:janakalyan_admin/widgets/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountTransfer extends StatefulWidget {
  AccountTransfer({Key? key}) : super(key: key);

  @override
  State<AccountTransfer> createState() => _AccountTransferState();
}

class _AccountTransferState extends State<AccountTransfer> {
  TextEditingController account = TextEditingController();

  TextEditingController name = TextEditingController();

  TextEditingController collector = TextEditingController();

  bool isLoading = false;
  late List<Collector> data;
  var selectedItem = "5";

  Future<List<Collector>> getCollector() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/collectors-list');
    //final url = Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();
        return parsed
            .map<Collector>((json) => Collector.fromJson(json))
            .toList();
      }
      return List<Collector>.empty();
    } catch (e) {
      throw e;
    }
  }

  void transfer() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/ac-transfer');

    var jsonBody = jsonEncode(<String, dynamic>{
      "collector": collector.text,
      "name": name.text,
      "accountNumber": account.text
    });

    try {
      var res = await http.post(url, body: jsonBody, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });

      if (200 == res.statusCode) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCollector();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Transfer'),
      ),
      body: Center(
        child: isLoading
            ? Center(child: CircularProgressIndicator.adaptive())
            : Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Account Transfer System",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customTextField(
                        account, "Account Number to be transferred"),
                    const SizedBox(
                      height: 15,
                    ),
                    customTextField(name, "Customer's Name"),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder<List<Collector>>(
                      future: getCollector(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Select an Collector"),
                              DropdownButton<String>(
                                value: selectedItem,
                                items: snapshot.data!.map((collector) {
                                  return DropdownMenuItem<String>(
                                    child: new Text(collector.id.toString()),
                                    value: collector.id.toString(),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedItem = newValue!;
                                  });
                                },
                              ),
                            ],
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                    InkWell(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          width: MediaQuery.of(context).size.width * 0.6,
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'Account Transfering',
                          desc:
                              'Ac: ${account.text} / New cc: ${collector.text}',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            transfer();
                            if (!isLoading) {
                              showDialog(
                                context: context,
                                builder: (__) => SuccessDialog(
                                  title: "Ac Transfer Successful",
                                  others:
                                      "Ac: ${account.text} / cc: ${collector.text}",
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => DashBoard(),
                                        ),
                                        (route) => false);
                                  },
                                ),
                              );
                            }
                          },
                        )..show();
                      },
                      child: Container(
                        width: 400,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            "Transfer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget customTextField(TextEditingController controller, String label) {
    return TextFormField(
      cursorWidth: 2.0,
      style: const TextStyle(color: Colors.black),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Required*';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.white),
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
        labelStyle: const TextStyle(color: Colors.black, letterSpacing: 2),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.white, width: 2, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
