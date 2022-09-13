import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddCollector extends StatefulWidget {
  AddCollector({Key? key}) : super(key: key);

  @override
  State<AddCollector> createState() => _AddCollectorState();
}

class _AddCollectorState extends State<AddCollector> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  bool isLoadnig = false;
  String dropdownvalue = "4";
  var items = [
    '3',
    '4',
    '5',
    '6',
  ];

  Future<void> addCollector() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/collector/create');
    var body = jsonEncode(<String, dynamic>{
      "name": name.text,
      "email": email.text,
      "password": password.text,
      "commissionRate": dropdownvalue
    });

    // print(dropdownvalue);
    try {
      var res = await http.post(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        //print(parsed);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Collector"),
      ),
      body: isLoadnig
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "Add a Collector",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomInputField(
                        controller: name,
                        label: "Name",
                        keyaboardType: TextInputType.text),
                    const SizedBox(height: 10),
                    CustomInputField(
                        controller: email,
                        label: "Email",
                        keyaboardType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomInputField(
                        controller: password,
                        label: "Passwod",
                        keyaboardType: TextInputType.visiblePassword),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Commission Rate (%)"),
                            DropdownButton(

                                // Initial Value
                                value: dropdownvalue,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!.split("%")[0];
                                  });
                                }),
                          ]),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          //addCollector();
                          if (name.text != "" &&
                              email.text != '' &&
                              password.text != '') {
                            setState(() {
                              isLoadnig = true;
                            });
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Adding Collector',
                              desc: "Email: ${email.text}",
                              btnCancelOnPress: () {
                                setState(() {
                                  isLoadnig = false;
                                });
                              },
                              btnOkOnPress: () async {
                                await addCollector();

                                setState(() {
                                  isLoadnig = false;
                                });

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashBoard()),
                                    (route) => false);
                              },
                            )..show();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "Add",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
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
}

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.keyaboardType})
      : super(key: key);
  final TextEditingController controller;
  final String label;
  final TextInputType keyaboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: TextFormField(
          keyboardType: keyaboardType,
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
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey, letterSpacing: 2),
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
