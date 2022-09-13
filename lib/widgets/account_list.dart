import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/screen/account_details/account_details.dart';
import 'package:janakalyan_admin/services/customer_services/customer.services.dart';


class AccountList extends StatefulWidget {
  // final Customer customer;

  //const AccountList(Key key):super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  CustomerServices customerServices = CustomerServices();
  final email = TextEditingController();
  num count = 0;
  List<Customer> list = [];

  String query = '';
  bool getAll = false;
  bool isFiltered = false;

  String collectorId = "5";

  List<String> collectorCodes = [
    '5',
    '15',
    '25',
    '35',
    '55',
    '75',
    '85',
    '135',
    '145',
  ];

  void call() async {
    num c = await customerServices.countCust();

    if (mounted) {
      setState(() {
        count = c;
      });
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

  @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      color: Colors.blueGrey,
      child: Column(
        children: [
          searchbox(
            email: email,
            count: count,
          ),
          Expanded(
            child: email.text.isNotEmpty
                ? FutureBuilder<List<Customer>>(
                    future: customerServices.getCustomerByAc(query),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const CircularProgressIndicator.adaptive();
                      } else if (snap.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.data?.length,
                            itemBuilder: (context, id) {
                              return CustomListTile(
                                customer: snap.data![id],
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
                  )
                : FutureBuilder<List<Customer>>(
                    future: !getAll
                        ? customerServices.getOnlyHundredCustomer()
                        : customerServices.getAllCustomer(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const CircularProgressIndicator.adaptive();
                      } else if (snap.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snap.data?.length,
                            itemBuilder: (context, id) {
                              return CustomListTile(
                                customer: snap.data![id],
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
          InkWell(
            onTap: () {
              setState(() {
                getAll = !getAll;
              });
            },
            child: Center(
              child: Text(
                getAll ? "See Less" : "Load More...",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

class searchbox extends StatelessWidget {
  const searchbox({
    Key? key,
    required this.email,
    this.count,
  }) : super(key: key);

  final TextEditingController email;
  final num? count;

  ///get-customer/:ac

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: TextFormField(
          cursorWidth: 2.0,
          style: const TextStyle(color: Colors.white),
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
