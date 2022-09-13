import 'package:flutter/material.dart';
import 'package:janakalyan_admin/models/expense_model.dart';
import 'package:janakalyan_admin/services/expenses/expenses.services.dart';
import 'package:janakalyan_admin/utils/formated_date.dart';

class ExpenseHistory extends StatefulWidget {
  ExpenseHistory({Key? key}) : super(key: key);

  @override
  State<ExpenseHistory> createState() => _ExpenseHistoryState();
}

class _ExpenseHistoryState extends State<ExpenseHistory> {
  ExpenseServices expenseServices = ExpenseServices();

  DateTime selectedDate = DateTime.now();

  bool isSelected = false;
  bool getAll = false;

  Future<void> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          isSelected = false;
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
            isSelected
                ? FutureBuilder<List<ExpenseModel>>(
                    future: expenseServices.getExpensesByDate(
                        selectedDate.toString().split(" ")[0]),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return renderCashBook(snap.data);
                      } else if (snap.hasError) {
                        return const Center(child: Text("Error"));
                      } else {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                    })
                : FutureBuilder<List<ExpenseModel>>(
                    future: getAll
                        ? expenseServices.getAllExpenses()
                        : expenseServices.getExpenses(),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return renderCashBook(snap.data);
                      } else if (snap.hasError) {
                        return const Center(
                          child: Text("Error"),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                    }),
            const SizedBox(
              height: 20,
            ),
            !getAll
                ? InkWell(
                    onTap: () {
                      setState(() {
                        getAll = !getAll;
                      });
                    },
                    child: Container(
                      child: const Text(
                        "Load More...",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

SingleChildScrollView renderCashBook(List<ExpenseModel>? list) {
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
          DataColumn(label: Text('Particulars', style: style1)),
          DataColumn(label: Text('Amount', style: style1)),
          DataColumn(label: Text('Emp. No', style: style1)),
          DataColumn(label: Text('Flag', style: style1)),
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
                    '${document.particulars}',
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.amount}',
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.empNo}',
                    style: style,
                  )),
                  DataCell(Text(
                    '${document.flag}',
                    style: style,
                  )),
                ]))
            .toList(),
      ),
    ),
  );
}
