import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/services/edit_customer/edit_customer.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';

class EditCustomer extends StatelessWidget {
  final Customer customer;
  const EditCustomer({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Customer"),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Text(
                    "*Note: make changes to the each input field and press enter to update the changes.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                EditableDetails(
                  initialValue: customer.accountNumber.toString(),
                  keyName: "accountNumber",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.name.toString(),
                  keyName: "name",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.fatherName.toString(),
                  keyName: "fatherName",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.address.toString(),
                  keyName: "address",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.pinCode.toString(),
                  keyName: "pinCode",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.occupation.toString(),
                  keyName: "occupation",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.nomineeName.toString(),
                  keyName: "nomineeName",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.nomineeAddress.toString(),
                  keyName: "nomineeAddress",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.nomineePhone.toString(),
                  keyName: "nomineePhone",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.relation.toString(),
                  keyName: "relation",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.nomineeFatherName.toString(),
                  keyName: "nomineeFatherName",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.nomineeAge.toString(),
                  keyName: "nomineeAge",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.phone.toString(),
                  keyName: "phone",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.age.toString(),
                  keyName: "age",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.loanAccountNumber.toString(),
                  keyName: "loanAccountNumber",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.totalInstallments.toString(),
                  keyName: "totalInstallments",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.installmentAmount.toString(),
                  keyName: "installmentAmount",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.totalPrincipalAmount.toString(),
                  keyName: "totalPrincipalAmount",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.totalMaturityAmount.toString(),
                  keyName: "totalMaturityAmount",
                  acNo: customer.accountNumber!,
                ),
                EditableDetails(
                  initialValue: customer.totalCollection.toString(),
                  keyName: "totalCollection",
                  acNo: customer.accountNumber!,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Text(
                    "*Account Type must be ( \"daily\" / \"weekly\" / \"monthly\" )",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                EditableDetails(
                  initialValue: customer.accountType.toString(),
                  keyName: "accountType",
                  acNo: customer.accountNumber!,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Text(
                    "*Maturity Date must be in format yyyy-mm-dd (e.g. 2022-03-29)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                EditableDetails(
                  initialValue: customer.maturityDate.toString().split("T")[0],
                  keyName: "maturityDate",
                  acNo: customer.accountNumber!,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Text(
                    "*Opening Date must be in format yyyy-mm-dd (e.g. 2022-03-29)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                EditableDetails(
                  initialValue: customer.createdAt.toString().split("T")[0],
                  keyName: "createdAt",
                  acNo: customer.accountNumber!,
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                //   child: Text(
                //     "*Created At: ${formatDate(customer.createdAt)}",
                //     style: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }
}

class EditableDetails extends StatefulWidget {
  const EditableDetails({
    Key? key,
    required this.acNo,
    required this.initialValue,
    required this.keyName,
  }) : super(key: key);

  final String initialValue;
  final int acNo;
  final String keyName;

  @override
  State<EditableDetails> createState() => _EditableDetailsState();
}

class _EditableDetailsState extends State<EditableDetails> {
  final TextEditingController editable = TextEditingController();

  final EditCustomerServices editCustomerServices = EditCustomerServices();

  @override
  void initState() {
    super.initState();
    setState(() {
      editable.text = widget.initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 8,
        ),
        child: TextFormField(
          enabled: widget.keyName == "accountNumber" ? false : true,
          onChanged: (v) async {
            print(v);
          },
          cursorWidth: 2.0,
          style: const TextStyle(color: Colors.grey),
          validator: (val) {
            if (val!.isEmpty) {
              return 'Required*';
            }
            return null;
          },
          onFieldSubmitted: (v) async {
            print(v);
            await editCustomerServices.editCustomer(
                widget.acNo, widget.keyName, editable.text);
          },
          controller: editable,
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.red),
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
                borderSide: BorderSide(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            labelText: widget.keyName,
            labelStyle: const TextStyle(color: Colors.grey, letterSpacing: 3),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.black, width: 2, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }
}
