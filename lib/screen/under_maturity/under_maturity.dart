import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/screen/account_details/account_details.dart';
import 'package:janakalyan_admin/services/customer_services/customer.services.dart';

class UnderMaturity extends StatelessWidget {
  UnderMaturity({Key? key}) : super(key: key);
  CustomerServices customerServices = CustomerServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Under Maturity Accounts"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: FutureBuilder<List<Customer>>(
            future: customerServices.getMaturityAccounts(),
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
      color: Colors.black,
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
            style: const TextStyle(color: Colors.black, fontSize: 16),
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
        color: Colors.grey,
      ),
    );
  }
}
