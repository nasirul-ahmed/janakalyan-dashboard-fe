import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janakalyan_admin/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCustomerServices {
  Future<void> editCustomer(
      int accountNumber, String key, dynamic value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$janaklyan/api/admin/edit-customer');

    try {
      var body = jsonEncode(<String, dynamic>{
        "key": key,
        "value": value,
        "accountNumber": accountNumber
      });

      var res = await http.put(url, body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Authorization": "Bearer ${_prefs.getString('token')}"
      });
      if (200 == res.statusCode) {
        final parsed = jsonDecode(res.body);

        print(parsed);
      }
    } catch (e) {
      throw e;
    }
  }
}
