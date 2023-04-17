import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/Services/globals.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<http.Response> register(String name, String childName, String email, String password) async {
    Map data = {"name": name, "childName": childName, "email": email, "password": password};
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/register');
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.decode(response.body)['token']);
    }

    return response;
  }

  static Future<http.Response> changeEmail(String email) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    Map data = {"email": email, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}changeEmail');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> changePassword(String password) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"password": password, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}changePassword');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> sendAction(String childId, String value, String note, String createdAt) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    print('\x1B[31m object \x1B[0m');
    Map data = {"child_id": childId, "value": value, "note": note, "createdAt": createdAt, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}action');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> showAction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}action/show');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> sendChild(String name, String balance, String rfid) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"name": name, "balance": balance, "rfid": rfid, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}child');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> deleteChildById(String name) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"childName": name, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}child/delete');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> updateChildRFID(String name, String rfid) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"name": name, "rfid": rfid, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}child/edit');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> sendPassToEmail(String email) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    String? pinCode = localStorage.getString('pinCode');

    Map data = {"email": email, "pin": pinCode, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}sendPass');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> sendPin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    String? pinCode = localStorage.getString('pinCode');

    Map data = {"pin": pinCode, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}sendPin');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> updateChildBalance(String name, String balance) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"name": name, "balance": balance, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}child/updatechildbalance');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> showChild() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}child/show');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response> sendDescription(String description) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"description": description, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}contact');
    http.Response response = await http.post(url, headers: headers, body: body);

    return response;
  }

  static Future<http.Response?> login(String email, String password) async {
    Map data = {"email": email, "password": password};
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/login');

    try {
      http.Response response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.decode(response.body)['token']);
      } else if (response.statusCode == 400) {
        print('email or password is incorrect!');
      }

      return response;
    } on Exception catch (_) {
      print('Time out connection 😑');
    }

    return null;
  }

  static Future<http.Response?> logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    Map data = {"token": token};
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/logout');
    localStorage.remove('token');
    // ignore: unused_local_variable
    http.Response response = await http.post(url, headers: headers, body: body);

    // var res = json.decode(response.body);
    token = localStorage.getString('token');
    print('token    $token');

    return null;
  }

  static Future<http.Response?> deleteAccount() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');
    Map data = {"token": token};
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/delete');
    localStorage.remove('token');
    // ignore: unused_local_variable
    http.Response response = await http.post(url, headers: headers, body: body);

    // var res = json.decode(response.body);
    token = localStorage.getString('token');
    print('token    $token');

    return null;
  }
}
