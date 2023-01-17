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

bool waiting = false;

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
            body: SingleChildScrollView(
                child: Stack(children: [
          Image.asset('assets/home/bg-clouds.png', height: height, width: width, fit: BoxFit.cover),
          Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 40, 40),
              child: Center(
                  child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                    height: height * 0.12,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', width: width * 0.7),
                      SizedBox(
                          width: 200,
                          child: TextField(
                            textAlign: TextAlign.center,
                            autofocus: true,
                            // style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                            decoration: const InputDecoration(
                                // hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'),
                                border: InputBorder.none,
                                hintText: 'Parent name'),
                            onChanged: (value) => _parentName = value,
                          ))
                    ])),
                SizedBox(
                    height: height * 0.12,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', width: width * 0.7),
                      SizedBox(
                          width: 200,
                          child: TextField(
                            autofocus: true,
                            textAlign: TextAlign.center,
                            // style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                            decoration: const InputDecoration(
                                // hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'),
                                border: InputBorder.none,
                                hintText: 'Child name'),
                            onChanged: (value) => _childName = value,
                          ))
                    ])),
                SizedBox(
                    height: height * 0.12,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', width: width * 0.7),
                      SizedBox(
                          width: 200,
                          child: TextField(
                              autofocus: true,
                              textAlign: TextAlign.center,
                              // style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                              decoration: const InputDecoration(
                                  // hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'),
                                  border: InputBorder.none,
                                  hintText: 'Email Address'),
                              onChanged: (value) => _email = value))
                    ])),
                SizedBox(
                    height: height * 0.12,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', width: width * 0.7),
                      SizedBox(
                        width: 200,
                        child: TextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            // style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                            decoration: const InputDecoration(
                                // hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'),
                                border: InputBorder.none,
                                hintText: 'Password'),
                            onChanged: (value) => _password = value),
                      )
                    ])),
                SizedBox(
                    height: height * 0.12,
                    width: 300,
                    child: Stack(alignment: AlignmentDirectional.center, children: [
                      Image.asset('assets/settings/btn-login.png', width: width * 0.7),
                      SizedBox(
                          width: 200,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                            autofocus: true,
                            textAlign: TextAlign.center,
                            // style: const TextStyle(fontFamily: 'waytosun', color: Colors.black),
                            decoration: const InputDecoration(
                                // hintStyle: TextStyle(fontFamily: 'waytosun'), labelStyle: TextStyle(fontFamily: 'waytosun'),
                                border: InputBorder.none,
                                hintText: '4 Digit Code'),
                            onChanged: (value) => setPinCode(value),
                          ))
                    ])),
                StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () => _enableTouchId().then((value) => setState(() => touchId)),
                          child: Image.asset(touchId ? "assets/settings/cloud-switch-on.png" : "assets/settings/cloud-switch-off.png", height: height * 0.05, fit: BoxFit.cover)));
                }),
                Image.asset('assets/settings/text-turn-on-fingerprint.png', height: height * 0.015),
                SizedBox(
                    height: 70,
                    width: 300,
                    child: Stack(children: [
                      MaterialButton(child: Image.asset('assets/home/${waiting ? 'btn-create-account-deactive.png' : 'btn-create-account.png'}', height: 50), onPressed: () => createAccountPressed()),
                      Center(child: Visibility(maintainSize: true, maintainAnimation: true, maintainState: true, visible: waiting, child: const CircularProgressIndicator())),
                    ])),
                SizedBox(
                    height: 60,
                    child: TextButton(
                      child: const Text('Already have an account,\n Log in here.',
                          textAlign: TextAlign.center, style: TextStyle(shadows: <Shadow>[Shadow(offset: Offset(1.0, 1.0), blurRadius: 10.0, color: Colors.black)], fontSize: 15, color: Colors.white)),
                      onPressed: () => context.push('/login'),
                    ))
              ])))),
        ]))));
  }

  createAccountPressed() async {
    setState(() => waiting = true);
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    if (emailValid) {
      http.Response response = await AuthServices.register(_parentName, _childName, _email, _password);

      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await DatabaseHandler.deleteTable('children');
        await DatabaseHandler.deleteTable('parents');
        await DatabaseHandler.insert('children', {'name': _childName, 'balance': '0', 'rfid': ''});
        await DatabaseHandler.insert('parents', {'fullName': _parentName, 'email': _email, 'pin': pinCode})
            .then((value) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const NewHomePage())));
        setState(() => waiting = false);
      } else {
        if (!mounted) return;
        errorSnackBar(context, responseMap.values.first[0]);
        setState(() => waiting = false);
      }
    } else {
      errorSnackBar(context, 'email not valid');
      setState(() => waiting = false);
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
