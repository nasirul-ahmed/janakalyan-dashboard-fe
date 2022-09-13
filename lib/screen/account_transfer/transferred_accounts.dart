import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:dio/dio.dart';
import 'package:janakalyan_admin/screen/account_details/account_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferredAccounts extends StatefulWidget {
  const TransferredAccounts({Key? key}) : super(key: key);

  @override
  State<TransferredAccounts> createState() => _TransferredAccountsState();
}

class _TransferredAccountsState extends State<TransferredAccounts> {
  final queryController = TextEditingController();
  num count = 0;
  List<Customer> list = [];
  List<Customer> filteredList = [];

  String query = '';
  bool isLoading = true;

  void getTransferredAccounts() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/transferred-accounts');

    try {
      var res = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

        List<Customer> data =
            parsed.map<Customer>((json) => Customer.fromJson(json)).toList();

        setState(() {
          list = filteredList = data;
          count = data.length;
          isLoading = false;
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  void filterByName() {
    setState(() {
      filteredList = list
          .where((customer) =>
              customer.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    getTransferredAccounts();

    queryController.addListener(() {
      query = queryController.text;
    });

    count = list.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transferred Accounts"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        color: Colors.blueGrey,
        child: Column(
          children: [
            SearchBar(),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, id) {
                        return CustomListTile(
                          customer: filteredList[id],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget SearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: TextFormField(
          onChanged: (e) => filterByName(),
          cursorWidth: 2.0,
          style: const TextStyle(color: Colors.white),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Required*';
            }
            return null;
          },
          controller: queryController,
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.white),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            labelText: 'Search an Account ($count)',
            labelStyle: const TextStyle(color: Colors.white, letterSpacing: 3),
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

class CustomListTile extends StatelessWidget {
  final Customer customer;
  const CustomListTile({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      color: Colors.white,
    );

    return ListTile(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AccountDetailsPage(
              customer: customer,
            ),
          ),
        )
      },
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            customer.loanAccountNumber != 0
                ? "Loan A/c: ${customer.loanAccountNumber}"
                : '',
            style: const TextStyle(color: Colors.amber, fontSize: 18),
          ),
          Text(
            "C. Amnt: ${customer.totalCollection}/-",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
      title: Text(
        "${customer.name} ",
        style: style,
      ),
      subtitle: Text(
        "Account: ${customer.accountNumber} / C.C: ${customer.agentUid}",
        style: style,
      ),
      leading: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
