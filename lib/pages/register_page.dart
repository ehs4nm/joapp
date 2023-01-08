import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jooj_bank/models/database_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/Services/auth_services.dart';
import 'package:go_router/go_router.dart';

import '/Services/globals.dart';
import 'package:http/http.dart' as http;
import '/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool touchId = false;
  String _email = '';
  String _password = '';
  String _childName = '';
  String _parentName = '';
  String pinCode = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                              textAlign: TextAlign.center,
                              autofocus: true,
                              style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                              decoration:
                                  const InputDecoration(hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Parent name'),
                              onChanged: (value) => _parentName = value,
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
                              autofocus: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                              decoration:
                                  const InputDecoration(hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Child name'),
                              onChanged: (value) => _childName = value,
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
                              autofocus: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Email Address'),
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
                              autofocus: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                              decoration:
                                  const InputDecoration(hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Password'),
                              onChanged: (value) => _password = value,
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
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                              autofocus: true,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: '4 Digit Code'),
                              onChanged: (value) => setPinCode(value),
                            ),
                          ),
                        ]),
                      ),
                      // const SizedBox(height: 20, width: 200),
                      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _enableTouchId().then((value) => setState(() => touchId)),
                            child: Image.asset(touchId ? "assets/settings/cloud-switch-on.png" : "assets/settings/cloud-switch-off.png", height: 35, fit: BoxFit.cover),
                          ),
                        );
                      }),
                      Image.asset('assets/settings/text-turn-on-fingerprint.png', height: 12),
                      SizedBox(
                        height: 70,
                        width: 300,
                        child: MaterialButton(
                          child: Image.asset('assets/home/btn-create-account.png', height: 50),
                          onPressed: () => createAccountPressed(),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: TextButton(
                          child: const Text('Already have an account,\n Log in here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(shadows: <Shadow>[
                                Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black),
                              ], fontSize: 15, color: Colors.white)),
                          onPressed: () => context.push('/login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  createAccountPressed() async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    if (emailValid) {
      http.Response response = await AuthServices.register(_parentName, _email, _password);

      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        DatabaseHandler.insert('children', {'name': _childName, 'balance': '0', 'rfid': 'Start'});
        DatabaseHandler.insert('parents', {'fullName': _parentName, 'email': _email, 'pin': pinCode});
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NewHomePage()));
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
      errorSnackBar(context, 'email not valid');
    }
  }

  _enableTouchId() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('touchId', !touchId);
    touchId = prefs.getBool('touchId') ?? false;
    return touchId;
  }

  void setPinCode(pinCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pinCode', pinCode);
  }
}
