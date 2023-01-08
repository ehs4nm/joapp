import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '/Services/globals.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static Future<http.Response> register(String name, String email, String password) async {
    Map data = {"name": name, "email": email, "password": password};
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

  static Future<http.Response> sendDescription(String description) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');

    Map data = {"description": description, "token": token};

    var body = json.encode(data);
    var url = Uri.parse('${baseURL}description');
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
    http.Response response = await http.post(url, headers: headers, body: body);

    // var res = json.decode(response.body);
    localStorage.remove('token');

    // if (res['success']) {
    // }
    return null;
  }
}
