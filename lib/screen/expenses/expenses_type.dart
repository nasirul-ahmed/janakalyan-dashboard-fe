import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:janakalyan_admin/models/expense_model.dart';
import 'package:janakalyan_admin/models/salary_model.dart';
import 'package:janakalyan_admin/screen/expenses/expense_history.dart';
import 'package:janakalyan_admin/screen/expenses/salary_history.dart';
import 'package:janakalyan_admin/screen/homescreen/dashboard.dart';
import 'package:janakalyan_admin/services/expenses/expenses.services.dart';
import 'package:janakalyan_admin/services/salary_services/salary_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:month_year_picker/month_year_picker.dart';

class ExpensesType extends StatefulWidget {
  ExpensesType({Key? key}) : super(key: key);

  @override
  State<ExpensesType> createState() => _ExpensesTypeState();
}

class _ExpensesTypeState extends State<ExpensesType> {
  TextEditingController amountController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  ExpenseServices expenseServices = ExpenseServices();
  SalaryServices salaryServices = SalaryServices();
  //expenses

  int? selectedValue;
  String? selectedString;

  DateTime selectedDate = DateTime.now();
  List<String> expensesType = [
    'Tea/coffee',
    'Room Rent',
    'Electricity Bill',
    'Press',
    'Others',
  ];

  // salary
  int? flag;
  String? flagString;
  List<String> employees = [
    'Rakibul Sadik',
    'Nehuja Khatun',
  ];
  DateTime? payMonth;

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

  Future<void> _onPressed({
    required BuildContext context,
  }) async {
    final selectedMonth = await showMonthYearPicker(
      context: context,
      initialDate: payMonth ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );

    if (selectedMonth != null) {
      setState(() {
        payMonth = selectedMonth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    const style1 = TextStyle(
      color: Colors.white,
      fontSize: 18,
    );
    const style2 = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Type"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: screen.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 80,
                        width: screen.width / 2 - 5.5,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            "Add an expense",
                            style: style1,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: screen.width / 2 - 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Expenses Types"),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  'Select expense',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: expensesType
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedString,
                                onChanged: (value) {
                                  setState(() {
                                    switch (value) {
                                      case "Tea/coffee":
                                        selectedValue = 1;
                                        selectedString = value as String;
                                        break;
                                      case "Room Rent":
                                        selectedValue = 2;
                                        selectedString = value as String;
                                        break;
                                      case "Electricity Bill":
                                        selectedValue = 3;
                                        selectedString = value as String;
                                        break;
                                      case "Others":
                                        selectedValue = 4;
                                        selectedString = value as String;
                                        break;
                                      case "Press":
                                        selectedValue = 5;
                                        selectedString = value as String;
                                        break;
                                    }
                                  });
                                },
                                buttonHeight: 40,
                                buttonWidth: 140,
                                itemHeight: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputField(
                        screen: screen,
                        textEditingController: amountController,
                        placeholder: "Enter Expense Amount",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (selectedValue != null &&
                              amountController.text.isNotEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Adding Expenses',
                              desc:
                                  'to ${selectedString} with amount of Rs: ${amountController.text}',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                expenseServices.addExpense(
                                    int.parse(amountController.text),
                                    selectedString.toString(),
                                    DateTime.now().toString(),
                                    selectedValue ?? 4,
                                    0);
                                Future.delayed(const Duration(seconds: 5));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DashBoard()));
                              },
                            )..show();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue[800],
                          ),
                          child: const Center(
                            child: Text(
                              "Add Expense",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 80,
                        width: screen.width / 2 - 5.5,
                        color: Colors.green,
                        child: const Center(
                          child: Text(
                            "Salary",
                            style: style2,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: screen.width / 2 - 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Select Employee"),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  'Select employee',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: employees
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: flagString,
                                onChanged: (value) {
                                  setState(() {
                                    switch (value) {
                                      case "Rakibul Sadik":
                                        flag = 100;
                                        flagString = value as String;
                                        break;
                                      case "Nehuja Khatun":
                                        flag = 101;
                                        flagString = value as String;
                                        break;
                                    }
                                  });
                                },
                                buttonHeight: 40,
                                buttonWidth: 140,
                                itemHeight: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInputField(
                        screen: screen,
                        textEditingController: salaryController,
                        placeholder: "Enter Salary Amount",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (payMonth == null)
                        const Text('No month year selected.')
                      else
                        Text(formatDate(payMonth)),
                      Row(
                        children: [
                          const Text("Select Pay Month"),
                          InkWell(
                              onTap: () => _onPressed(context: context),
                              child: Text(formatDate(payMonth)))
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: const Text(
                                "Select a process date",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 100,
                            ),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: Text(
                                formatDate(selectedDate),
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 18),
                              ),
                            )
                          ]),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (flag != null &&
                              salaryController.text.isNotEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Paying Salary',
                              desc: 'Salary amnt : ${salaryController.text}',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                salaryServices.createSalary(
                                    int.parse(amountController.text),
                                    flagString!,
                                    selectedDate.toString(),
                                    flag!);
                                // expenseServices.addExpense(
                                //   ,
                                //   "Paying salary to " + flagString!,
                                //   selectedDate.toString(),
                                //   flag!,
                                //   flag!,
                                // );
                                Future.delayed(const Duration(seconds: 5));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DashBoard(),
                                  ),
                                );
                              },
                            )..show();
                          }
                        },
                        child: const CustomButtonb(
                          label: "Pay Salary",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseHistory(),
                          ),
                        );
                      },
                      child: const Text("Expense History")),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalaryHistory(),
                          ),
                        );
                      },
                      child: const Text("Salary History"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget customSalaryHistoryTile(Salary salary) {
  //   return ListTile(
  //     leading: Text(salary.id.toString()),
  //     title: Text("Name: " + salary.employeeName!),
  //     subtitle: Text("Emplyee No: " + salary.empNo.toString()),
  //     trailing: Row(
  //       children: [
  //         Text("Paid Amnt: " + salary.salaryAmount.toString()),
  //         Text("Dated: " + formatDate(salary.createdAt)),
  //       ],
  //     ),
  //   );

  //   //Text(salary.employeeName.toString());
  // }

  // Widget customExpenseHistoryTile(ExpenseModel expenseModel) {
  //   return ListTile(
  //     leading: Text(expenseModel.id.toString()),
  //     title: Text("Particulars: " + expenseModel.particulars!),
  //     subtitle: Text("Amount: " + expenseModel.amount.toString()),
  //     trailing: Text("Date Amnt: " + formatDate(expenseModel.createdAt)),
  //   );
  // }
}

class CustomButtonb extends StatelessWidget {
  final label;
  const CustomButtonb({Key? key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.blue[800],
      ),
      child: Center(
        child: Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final screen;
  final textEditingController;
  final placeholder;
  const CustomInputField(
      {Key? key, this.screen, this.textEditingController, this.placeholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screen.width / 2 - 20,
      padding: EdgeInsets.all(10),
      child: TextFormField(
        cursorWidth: 2.0,
        style: const TextStyle(color: Colors.black),
        validator: (val) {
          if (val!.isEmpty) {
            return 'Required*';
          }
          return null;
        },
        controller: textEditingController,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          labelText: placeholder,
          labelStyle: const TextStyle(color: Colors.black, letterSpacing: 3),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Colors.black, width: 2, style: BorderStyle.none),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
// Flexible(
//                     flex: 1,
//                     child: FutureBuilder<List<Salary>>(
//                         future: salaryServices.getAllSalaries(),
//                         builder: (context, snap) {
//                           if (snap.hasError) {
//                             return const Center(
//                               child: Text("Error"),
//                             );
//                           } else if (snap.hasData) {
//                             return SizedBox(
//                               width: screen.width / 2 - 15,
//                               child: SingleChildScrollView(
//                                 child: ListView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: snap.data!.length,
//                                     itemBuilder: (context, id) {
//                                       return customSalaryHistoryTile(
//                                           snap.data![id]);
//                                     }),
//                               ),
//                             );
//                           } else {
//                             return const SizedBox(
//                               height: 40,
//                               width: 40,
//                               child: CircularProgressIndicator.adaptive(),
//                             );
//                           }
//                         }),
//                   )

 // Flexible(
                  //   flex: 1,
                  //   child: FutureBuilder<List<ExpenseModel>>(
                  //       future: expenseServices.getAllExpenses(),
                  //       builder: (context, snap) {
                  //         if (snap.hasError) {
                  //           return const Text("No data/Error");
                  //         } else if (snap.hasData) {
                  //           return SizedBox(
                  //             width: screen.width / 2 - 5.5,
                  //             child: SingleChildScrollView(
                  //               child: ListView.builder(
                  //                   shrinkWrap: true,
                  //                   itemCount: snap.data!.length,
                  //                   itemBuilder: (context, id) {
                  //                     return customExpenseHistoryTile(
                  //                         snap.data![id]);
                  //                   }),
                  //             ),
                  //           );
                  //         } else {
                  //           return const SizedBox(
                  //             height: 40,
                  //             width: 40,
                  //             child: CircularProgressIndicator.adaptive(),
                  //           );
                  //         }
                  //       }),
                  // )