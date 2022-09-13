// import 'dart:convert';
// import 'package:janakalyan_admin/constants/constants.dart';
// import 'package:janakalyan_admin/models/customer_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class TranferredAccountServices {
//   // List<Customer> tranferredAccounts = List.empty();

//   // List<Customer> getTranferredAccounts() {
//   //   return this.tranferredAccounts;
//   // }

//   // void printAll(){
//   //   print(tranferredAccounts);
//   // }

//   void fetch() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     final url = Uri.parse('$janaklyan/api/admin/get-customer');

//     try {
//       var res = await http.get(url, headers: {
//         "Content-Type": "application/json",
//         "Accept": "*/*",
//         "Authorization": "Bearer ${_prefs.getString('token')}"
//       });
//       if (200 == res.statusCode) {
//         List parsed = jsonDecode(res.body).cast<Map<String, dynamic>>();

//         List<Customer> list =
//             parsed.map<Customer>((json) => Customer.fromJson(json)).toList();
       
//         }
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
