// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Services/auth_services.dart';
import '/Services/globals.dart';
import 'package:http/http.dart' as http;
import '/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/home/bg-clouds.png', height: height, width: width, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 30, 40, 40),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                            // style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                            decoration: const InputDecoration(
                              // hintStyle: TextStyle(fontFamily: 'waytosun'),
                              // labelStyle: TextStyle(fontFamily: 'waytosun'),
                              border: InputBorder.none,
                              hintText: 'Email Address',
                            ),
                            onChanged: (value) => _email = value,
                          ),
                        ),
                      ]),
                    ),
                    // const SizedBox(height: 10, width: 200),
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
                            // style: TextStyle(fontFamily: 'waytosun', color: Colors.blueGrey.shade900),
                            decoration: const InputDecoration(
                                // hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.blueGrey.shade900),
                                // labelStyle: TextStyle(fontFamily: 'waytosun', color: Colors.blueGrey.shade900),
                                border: InputBorder.none,
                                hintText: 'Password'),
                            onChanged: (value) => _password = value,
                          ),
                        ),
                      ]),
                    ),

                    SizedBox(
                      height: 70,
                      width: 300,
                      child: MaterialButton(
                        child: Image.asset('assets/home/btn-login-account.png', height: 100),
                        onPressed: () => loginPressed(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  loginPressed() async {
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email)) {
      errorSnackBar(context, 'Enter a valid email address');
    } else if (_email.isNotEmpty && _password.isNotEmpty) {
      try {
        http.Response? response = await AuthServices.login(_email, _password);
        if (response == null || response.statusCode == 500) {
          errorSnackBar(context, 'Network connection error!');
          return;
        }

        Map responseMap = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NewHomePage()));
        } else {
          errorSnackBar(context, responseMap.values.first);
        }
      } on Exception {
        print('Time out connection 😑');
      }
    } else {
      errorSnackBar(context, 'Enter all required fields');
    }
  }
}
