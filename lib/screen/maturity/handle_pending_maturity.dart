import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:janakalyan_admin/models/maturity.dart';
import 'package:janakalyan_admin/screen/maturity/maturity_list.dart';
import 'package:janakalyan_admin/screen/passbook/deposit_passbook.dart';
import 'package:janakalyan_admin/services/maturity/maturity.services.dart';
import 'package:janakalyan_admin/services/passbook_services/passbook_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';

class HandlePendingMaturity extends StatefulWidget {
  final Maturity maturity;
  final bool isMatured;
  HandlePendingMaturity(
      {Key? key, required this.maturity, required this.isMatured})
      : super(key: key);

  @override
  State<HandlePendingMaturity> createState() => _HandlePendingMaturityState();
}

class _HandlePendingMaturityState extends State<HandlePendingMaturity> {
  TextEditingController depositAmount = TextEditingController(text: "0");

  TextEditingController prematurityCharge = TextEditingController(text: "0");

  TextEditingController interestAmount = TextEditingController(text: "0");

  MaturityServices maturityServices = MaturityServices();
  int deposit = 0;
  int interest = 0;
  int charge = 0;
  DateTime selectedDate = DateTime.now();

  PassbookServices passbookServices = PassbookServices();
  late Customer customer;

  Future<void> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future getPassBook() async {
    customer =
        await passbookServices.getCustomerByAc(widget.maturity.accountNumber);
  }

  @override
  void initState() {
    super.initState();

    getPassBook();
    depositAmount.addListener(() {
      setState(() {
        deposit =
            depositAmount.text.isEmpty ? 0 : int.parse(depositAmount.text);
      });
    });
    prematurityCharge.addListener(() {
      setState(() {
        charge = prematurityCharge.text.isEmpty
            ? 0
            : int.parse(prematurityCharge.text);
      });
    });
    interestAmount.addListener(() {
      setState(() {
        interest =
            interestAmount.text.isEmpty ? 0 : int.parse(interestAmount.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const style =
        TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1.6);
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isMatured ? "Maturity Submission" : "Maturity Processing"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Card(
                    elevation: 16,
                    child: Container(
                      height: 50,
                      width: screen.width * 0.5,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          widget.maturity.isPreMaturity == 0
                              ? "Maturity"
                              : "Pre-Maturity",
                          style: style,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: screen.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRows(
                          label: "Name",
                          data: widget.maturity.custName.toString()),
                      CustomRows(
                          label: "Father's Name",
                          data: widget.maturity.fathersName.toString()),
                      CustomRows(
                          label: "Address",
                          data: widget.maturity.address.toString()),
                      CustomRows(
                          label: "Account No.",
                          data: widget.maturity.accountNumber.toString()),
                      CustomRows(
                          label: "Collector Code",
                          data: widget.maturity.collectorId.toString()),
                      CustomRows(
                          label: "Account opening Date",
                          data: formatDate(widget.maturity.openingDate)),
                      CustomRows(
                          label: "M. Submit Date",
                          data: formatDate(widget.maturity.submitDate)),
                      //
                      //
                      //
                      widget.isMatured
                          ? CustomRows(
                              label: "M. Processing Date",
                              data: formatDate(widget.maturity.processDate))
                          : const SizedBox(),
                      CustomRows(
                          label: "Maturity Value (Rs)",
                          data:
                              widget.maturity.maturityValue.toString() + "/-"),
                      CustomRows(
                          label: "Deposit Amount (Rs)",
                          data:
                              widget.maturity.maturityAmount.toString() + "/-"),

                      ///
                      customFieldss(
                          controller: depositAmount, label: "Deposit Amount"),
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      widget.maturity.isPreMaturity == 1
                          ? customFieldss(
                              controller: prematurityCharge,
                              label: "Pre Maturity Charge")
                          : customFieldss(
                              controller: interestAmount,
                              label: "Interest Amount"),
                      //
                      const SizedBox(
                        height: 10,
                      ),

                      widget.maturity.isPreMaturity == 1
                          ? CustomRows(
                              label: "Pre Maturity Charge (Rs)",
                              data: "- " + charge.toString())
                          : CustomRows(
                              label: "Maturity Interest (Rs)",
                              data: "+ " + interest.toString()),

                      widget.maturity.isPreMaturity == 1
                          ? CustomRows(
                              label: "Net Payable Amount (Rs)",
                              data: "${deposit - charge}")
                          : const SizedBox(),
                      widget.maturity.isPreMaturity == 0
                          ? CustomRows(
                              label: "Net Payable Amount (Rs)",
                              data: "${deposit + interest}")
                          : const SizedBox(),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: Text(
                                "Select a process date",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                            ),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: Text(
                                formatDate(selectedDate),
                                style: TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                            )
                          ]),

                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        child: InkWell(
                          onTap: () {
                            var maturity = widget.maturity;
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Maturing A/c ${maturity.accountNumber}?',
                              desc:
                                  'Total Amount : ${deposit + interest - charge} /-',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                await maturityServices.processMaturity(
                                  maturity.id!,
                                  maturity.maturityValue!,
                                  selectedDate.toString(),
                                  deposit,
                                  interest,
                                  charge,
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MaturityList()));
                              },
                            )..show();
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text(
                                !widget.isMatured
                                    ? "Process Maturity"
                                    : "Mature this Account",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () => {
                          // setState(() {
                          //   isLoading = !isLoading;
                          // })
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DepositPassbook(doc: customer)))
                        },
                        child: Container(
                          width: screen.width * 0.5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "See Passbook",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          await maturityServices.rejectMaturity(
                              widget.maturity.id!,
                              widget.maturity.accountNumber!);
                        },
                        child: Container(
                          width: screen.width * 0.5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "Reject Maturity",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

class customFieldss extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const customFieldss({Key? key, required this.controller, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: TextFormField(
        onChanged: (s) {
          print(s);
        },
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
          labelStyle: const TextStyle(color: Colors.grey, letterSpacing: 3),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.grey, width: 2, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}

class CustomRows extends StatelessWidget {
  final String label;
  final String data;
  const CustomRows({Key? key, required this.label, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black, fontSize: 16);
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style,
          ),
          Text(
            data,
            style: style,
          ),
        ],
      ),
    );
  }
}
