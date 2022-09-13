import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/utils/isNumber.dart';
import 'package:janakalyan_admin/widgets/account_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MaturedAccounts extends StatefulWidget {
  MaturedAccounts({Key? key}) : super(key: key);

  @override
  State<MaturedAccounts> createState() => _MaturedAccountsState();
}

class _MaturedAccountsState extends State<MaturedAccounts> {
  TextEditingController email = TextEditingController();

  num count = 0;

  List<Customer> list = [];

  String query = '';

  Future<List<Customer>> getCustomer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/get-matured-customer');
    //final url =Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();

        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Customer>> getCustomerByAcOrName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    final url = isNumeric(query)
        ? Uri.parse('$janaklyan/api/admin//get-matured-customer/ac')
        : Uri.parse('$janaklyan/api/admin//get-matured-customer/name');
    //final url =Uri.parse("uri");
    try {
      var res = await http.post(url,
          body: jsonEncode(<String, dynamic>{"searched": query}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer ${_prefs.getString('token')}"
          });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> list =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();

        return list;
      }
      return List<Customer>.empty();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<num> countCust() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/count-matured');
    //final url =Uri.parse("uri");
    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);
        print(parsed[0]["count"]);
        return parsed[0]["count"];
      } else
        return 0;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    call();
    email.addListener(() {
      setState(() {
        query = email.text;
      });
    });
  }

  void call() async {
    num c = await countCust();

    if (mounted) {
      setState(() {
        count = c;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matured Accounts"),
      ),
      body: Container(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          color: Colors.blueGrey,
          child: Column(
            children: [
              searchbox(
                email: email,
                count: count,
              ),
              Expanded(
                child: FutureBuilder<List<Customer>>(
                  future: email.text.isNotEmpty
                      ? getCustomerByAcOrName()
                      : getCustomer(),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return const CircularProgressIndicator.adaptive();
                    } else if (snap.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snap.data?.length,
                          itemBuilder: (context, id) {
                            return CustomListTile(customer: snap.data![id]);
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
