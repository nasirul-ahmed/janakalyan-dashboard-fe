import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/salary_model.dart';
import 'package:janakalyan_admin/services/salary_services/salary_services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';
import 'package:janakalyan_admin/models/expense_model.dart';
import 'package:janakalyan_admin/services/expenses/expenses.services.dart';

class SalaryHistory extends StatefulWidget {
  SalaryHistory({Key? key}) : super(key: key);

  @override
  State<SalaryHistory> createState() => _SalaryHistoryState();
}

class _SalaryHistoryState extends State<SalaryHistory> {
  ExpenseServices expenseServices = ExpenseServices();

  SalaryServices salaryServices = SalaryServices();

  DateTime selectedDate = DateTime.now();

  bool isSelected = false;
  bool getAll = false;

  List<Salary> salaries = [];
  List<Salary> filteredSalaries = [];
  bool isLoading = true;

  void setSalaries() async {
    List<Salary> x = await salaryServices.getAllSalaries();
    setState(() {
      salaries = filteredSalaries = x;
      isLoading = false;
    });
  }

  void filterSalary() {
    setState(() {
      filteredSalaries = salaries
          .where((salary) =>
              salary.createdAt!.split("T")[0] ==
              selectedDate.toString().split(" ")[0])
          .toList();    
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      filterSalary();
      setState(() {
        selectedDate = picked;
        isSelected = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setSalaries();
  }

  @override
  Widget build(BuildContext context) {
    //  print(salaries[0].employeeName);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loss and Profit"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(left: 50, right: 50),
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Text(
                        "Select date :  ${formatDate(selectedDate)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          filteredSalaries = salaries;
                          // isSelected = false;
                          selectedDate = DateTime.now();
                        });
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),

            !isLoading
                ? renderSalary(filteredSalaries)
                : Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),

            // salaries.map((e) => renderCashBook(snap.data))
            const SizedBox(
              height: 20,
            ),
            // !getAll
            //     ? InkWell(
            //         onTap: () {
            //           setState(() {
            //             getAll = !getAll;
            //           });
            //         },
            //         child: Container(
            //           child: const Text(
            //             "Load More...",
            //             style: TextStyle(color: Colors.green),
            //           ),
            //         ),
            //       )
            //     : const SizedBox(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

SingleChildScrollView renderSalary(List<Salary>? list) {
  const style = TextStyle(color: Colors.black, fontSize: 16);
  const style1 = TextStyle(color: Colors.black, fontSize: 16);
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        // columnSpacing: 25,
        // horizontalMargin: 10,
        columns: [
          DataColumn(label: Text('C.Id', style: style1)),
          DataColumn(label: Text('Date', style: style1)),
          DataColumn(label: Text('Amount', style: style1)),
          DataColumn(label: Text('Emp. No', style: style1)),
        ],
        rows: list!
            .map((document) => DataRow(cells: [
                  DataCell(Text(
                    '${document.id}',
                    style: style,
                  )),
                  DataCell(Text(
                    formatDate(document.createdAt),
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.salaryAmount}',
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.empNo}',
                    style: style,
                  )),
                ]))
            .toList(),
      ),
    ),
  );
}


// class SalaryHistory extends StatelessWidget {
//   SalaryHistory({Key? key}) : super(key: key);

//   SalaryServices salaryServices = SalaryServices();

//   @override
//   Widget build(BuildContext context) {
//     var screen = MediaQuery.of(context).size;

//     return Container(
//       child: FutureBuilder<List<Salary>>(
//           future: salaryServices.getAllSalaries(),
//           builder: (context, snap) {
//             if (snap.hasError) {
//               return const Center(
//                 child: Text("Error"),
//               );
//             } else if (snap.hasData) {
//               return SizedBox(
//                 width: screen.width / 2 - 15,
//                 child: SingleChildScrollView(
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: snap.data!.length,
//                       itemBuilder: (context, id) {
//                         return customSalaryHistoryTile(snap.data![id]);
//                       }),
//                 ),
//               );
//             } else {
//               return const SizedBox(
//                 height: 40,
//                 width: 40,
//                 child: CircularProgressIndicator.adaptive(),
//               );
//             }
//           }),
//     );
//   }

//   Widget customSalaryHistoryTile(Salary salary) {
//     return ListTile(
//       leading: Text(salary.id.toString()),
//       title: Text("Name: " + salary.employeeName!),
//       subtitle: Text("Emplyee No: " + salary.empNo.toString()),
//       trailing: Row(
//         children: [
//           Text("Paid Amnt: " + salary.salaryAmount.toString()),
//           Text("Dated: " + formatDate(salary.createdAt)),
//         ],
//       ),
//     );

//     //Text(salary.employeeName.toString());
//   }
// }
