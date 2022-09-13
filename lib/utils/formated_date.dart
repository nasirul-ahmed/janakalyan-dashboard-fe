import 'package:intl/intl.dart';

String formatDate(inputDate) {
  final input = DateFormat('yyyy-MM-dd');
  final output = DateFormat('dd-MM-yyyy');
  final date = input.parse(inputDate.toString().split("T")[0]);
  final finalDate = output.format(date);
  return finalDate;
}
