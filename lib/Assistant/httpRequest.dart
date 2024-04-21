import 'dart:convert';

import 'package:http/http.dart' as http;

// ignore: camel_case_types
class httpRequest {
  static Future<dynamic> getRequest(String url) async {
    http.Response res = await http.get(Uri.parse(url));
    try {
      if (res.statusCode == 200) {
        String data = res.body;
        var decoded = jsonDecode(data);
        return decoded;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }
}
