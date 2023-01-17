// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:jooj_bank/models/models.dart';
import 'package:jooj_bank/providers/children_provider.dart';
import '/Services/auth_services.dart';
import '/Services/globals.dart';
import 'package:http/http.dart' as http;
import '/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

String _email = '';
String _password = '';
bool waiting = false;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Stack(children: [
          Image.asset('assets/home/bg-clouds.png', height: height, width: width, fit: BoxFit.cover),
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 40, 40),
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                    height: 90,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', height: 90),
                      SizedBox(
                          width: 200,
                          child: TextField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email Address',
                            ),
                            onChanged: (value) => _email = value,
                          ))
                    ])),
                SizedBox(
                    height: 90,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', height: 90),
                      SizedBox(
                          width: 200,
                          child: TextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Password'),
                            onChanged: (value) => _password = value,
                          ))
                    ])),
                SizedBox(
                  height: 70,
                  width: 300,
                  child: MaterialButton(
                    child: Image.asset('assets/home/${waiting ? 'btn-login-account-deactive.png' : 'btn-login-account.png'}', height: 100),
                    onPressed: () => loginPressed(),
                  ),
                ),
                SizedBox(
                    height: 90,
                    child: TextButton(
                      child: const Text("Don't have an account,\n Sign up here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(shadows: <Shadow>[
                            Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                          ], fontSize: 15, color: Colors.white)),
                      onPressed: () => context.push('/register'),
                    ))
              ])))),
          Center(child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: waiting, child: const CircularProgressIndicator())),
        ])));
  }

  loginPressed() async {
    setState(() => waiting = true);
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)) {
      errorSnackBar(context, 'Enter a valid email address');
    } else if (_email.isNotEmpty && _password.isNotEmpty) {
      try {
        http.Response? response = await AuthServices.login(_email, _password);
        if (response == null || response.statusCode == 500 || response.statusCode == 404) {
          errorSnackBar(context, 'Network connection error!');
          return;
        }

        Map responseMap = jsonDecode(response.body);
        if (response.statusCode == 200) {
          extractActions();
          extractChildren();
          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NewHomePage()));
        } else {
          errorSnackBar(context, responseMap.values.first);
        }
      } on Exception {
        print('Time out connection 😑');
      }
    } else {
      errorSnackBar(context, 'Enter all required fields');
    }
    setState(() => waiting = false);
  }

  extractActions() async {
    try {
      http.Response? response = await AuthServices.showAction();
      if (response.statusCode == 500 || response.statusCode == 404) {
        errorSnackBar(context, 'Network connection error!');
        return;
      }
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseMap.values.last.isNotEmpty) {
          var actionsJson = jsonDecode(response.body)['actions'] as List;
          List<BankAction> actions = actionsJson.map((e) => BankAction.fromJson(e)).toList();
          await DatabaseHandler.deleteTable('actions');
          for (var i = 0; i < actions.length; i++) {
            await DatabaseHandler.insert('actions', actions[i].toMap());
          }
        }
        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NewHomePage()));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } on Exception {
      print('Time out connection 😑');
    }
  }

  extractChildren() async {
    try {
      setState(() => waiting = true);
      http.Response? response = await AuthServices.showChild();
      if (response.statusCode == 500 || response.statusCode == 404) {
        errorSnackBar(context, 'Network connection error!');
        return;
      }
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseMap.values.last.isNotEmpty) {
          var childrenJson = jsonDecode(response.body)['children'] as List;
          List<Child> children = childrenJson.map((e) => Child.fromJson(e)).toList();
          await DatabaseHandler.deleteTable('children');
          for (var i = 0; i < children.length; i++) {
            await DatabaseHandler.insert('children', children[i].toMap());
          }
        }
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } on Exception {
      print('Time out connection 😑');
    }
  }
}
