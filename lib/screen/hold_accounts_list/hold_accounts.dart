import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/screen/account_details/account_details.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:janakalyan_admin/services/hold_account/hold_services.dart';

class HoldAccounts extends StatelessWidget {
  HoldAccounts({Key? key}) : super(key: key);
  TextEditingController accountNo = TextEditingController();

  HoldAccount holds = HoldAccount();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hold a account"),
      ),
      body: Container(
        child: FutureBuilder<List<Customer>>(
          future: holds.getHoldAccounts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("No data found"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, idx) {
                    return Center(
                      child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: HoldAccountLists(snapshot.data![idx])),
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
    );
  }
}

class HoldAccountLists extends StatelessWidget {
  Customer customer;

  HoldAccountLists(this.customer);

  HoldAccount holds = HoldAccount();

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      color: Colors.black,
    );

    return ListTile(
      tileColor: Colors.green[100],
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AccountDetailsPage(customer: customer)))
      },
      trailing: MaterialButton(
        elevation: 10,
        color: Colors.green,
        textColor: Colors.white,
        onPressed: () => {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Do you want to unhold?',
            desc: 'Account No : ${customer.accountNumber}',
            btnCancelOnPress: () {},
            btnOkOnPress: () => {
              holds.unhold(customer.accountNumber),
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DashBoard())),
            },
          )..show(),
        },
        child: const Text("Unhold account"),
      ),
      title: Text(
        "${customer.name}",
        style: style,
      ),
      subtitle: Text(
        "Account: ${customer.accountNumber}",
        style: style,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person),
      ),
    );
  }
}
