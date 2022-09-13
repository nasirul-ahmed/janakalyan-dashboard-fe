import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';

class AccountRegister extends StatelessWidget {
  const AccountRegister({Key? key, required this.customer}) : super(key: key);
  final Customer customer;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
      ),
      body: Center(
        child: Container(
          width: width * 0.7,
          child: ListView(
            children: [
              optionHeader("Account Details"),
              customListTile("Account Number", customer.accountNumber),
              customer.loanAccountNumber == null ||
                      customer.loanAccountNumber == 0
                  ? const SizedBox(height: 1)
                  : customListTile(
                      "Loan Account Number", customer.loanAccountNumber ?? 0),
              customListTile("Installemt", customer.installmentAmount ?? 0),
              customListTile(
                  "Principal Amount", customer.totalPrincipalAmount ?? 0),
              customListTile(
                  "Interest Amount", customer.totalInterestAmount ?? 0),
              customListTile(
                  "Maturity Amount", customer.totalMaturityAmount ?? 0),
              customListTile("Total Collection", customer.totalCollection ?? 0),
              customListTile("Opening Date", formatDate(customer.createdAt)),
              customListTile(
                  "Maturity Date", formatDate(customer.maturityDate)),
              customListTile("Account Type", customer.accountType ?? ""),
              optionHeader("Customer Details"),
              customListTile("Name", customer.name),
              customListTile(
                  "Address", customer.address.toString()),
              customListTile("Phone", customer.phone),
              customListTile("Father Name", customer.fatherName),
              customListTile("Age", customer.age),
              customListTile("Collector Code", customer.agentUid ?? 0),
              optionHeader("Nominee Details"),
              customListTile("Name", customer.nomineeName ?? ""),
              customListTile("Father Name", customer.nomineeFatherName ?? ""),
              customListTile("Relation", customer.relation ?? ""),
              customListTile(
                  "Adress", customer.nomineeAddress.toString()),
              customListTile("Age", customer.nomineeAge ?? 0),
              customListTile("Phone", customer.nomineePhone ?? 0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      optionHeader("Customer Photo"),
                      customer.profile == null
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  'No images',
                                  style: custStyle(
                                      Colors.black, FontWeight.normal, 18.0),
                                ),
                              ),
                            )
                          : Card(
                              child: Container(
                                height: 300,
                                width: 250,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        customer.profile.toString()),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  Column(
                    children: [
                      optionHeader("Customer Signature"),
                      customer.signature == null
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text(
                                  'No images',
                                  style: custStyle(
                                      Colors.black, FontWeight.normal, 18.0),
                                ),
                              ),
                            )
                          : Card(
                              child: Container(
                                height: 300,
                                width: 250,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        customer.signature.toString()),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle custStyle(color, fontw, size) {
    return TextStyle(color: color, fontWeight: fontw, fontSize: size);
  }

  Widget optionHeader(text) {
    return Card(
      child: Container(
        height: 40,
        width: 200,
        color: Colors.blueGrey[600],
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              text,
              style: custStyle(Colors.white, FontWeight.bold, 16.0),
            ),
          ),
        ),
      ),
    );
  }

  ListTile customListTile(String label, dynamic data) {
    return ListTile(
      title: Text(
        label,
        style: custStyle(Colors.black, FontWeight.normal, 16.0),
      ),
      //leading: Icon(Icons.label),
      trailing: Text(
        "$data",
        style: custStyle(
          Colors.black,
          FontWeight.bold,
          16.0,
        ),
      ),
    );
  }
}

