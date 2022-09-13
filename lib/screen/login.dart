import 'dart:convert';
import 'dart:html';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();
  bool isLoading = false;
  final storage = const FlutterSecureStorage();
  
  Future<dynamic> handlePress(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    const url = "$janaklyan/api/admin/admin-login";

    try {
      

      var res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          "Accept": "*/*",
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, String>{
          "email": "${email.text}",
          "password": "${password.text}"
        }),
      );

      if (200 == res.statusCode) {
        
        Map<String, dynamic> token = jsonDecode(res.body);
        if (token.isNotEmpty) {
          
          await pref.setString("token", token["token"]);
          await pref.setBool('isLogged', true);
          await pref.setInt('collectorId', token["id"]);
          await pref.setString('email', token["email"]);
          print(token["token"]);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) =>const DashBoard()), (route) => false);
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    'Logging',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
          )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: 'Jana',
                        style: TextStyle(
                          color: Colors.red,
                          letterSpacing: 5.0,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Kalayan',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 5.0,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        cursorWidth: 2.0,
                        style: const TextStyle(color: Colors.black),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Required*';
                          }
                          return null;
                        },
                        controller: email,
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(color: Colors.white),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                              color: Colors.black, letterSpacing: 3),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                                style: BorderStyle.none),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'Reuired*';
                          }
                          return null;
                        },
                        enabled: true,
                        style: const TextStyle(color: Colors.black),
                        obscureText: true,
                        controller: password,
                        decoration: InputDecoration(
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          errorBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))),
                          //errorText: errorMsg ? 'Invalid Email and password' : null,
                          errorStyle: const TextStyle(color: Colors.red),
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            letterSpacing: 3,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.orange[800],
                    ),
                    width: 150,
                    child: MaterialButton(
                      //focusColor: Colors.amber[700],
                      //color: Colors.teal,
                      onPressed: () => handlePress(context),
                      minWidth: 150.0,
                      height: 50.0,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
