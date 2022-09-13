import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:janakalyan_admin/models/customer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassbookServices {
  Future<Customer> getCustomerByAc(int? ac) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse("$janaklyan/api/admin/processed-matured-customer/ac");
    var body = jsonEncode(<String, dynamic>{"searched": ac});
    try {
      var res = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
        'Accept': "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}",
      });
      if (200 == res.statusCode) {
        final parsed = await jsonDecode(res.body);
        print(parsed);
        return Customer.fromJson(parsed[0]);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
