import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jooj_bank/Services/auth_services.dart';
import 'package:jooj_bank/Services/globals.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/Pin_keyboard.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool confirmed = false;
  int pinLength = 0;
  late String pinCode;
  late String curentPinCode;

  void setPinCode(pinCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pinCode', pinCode);
  }

  void getPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    curentPinCode = prefs.getString('pinCode') ?? '1234';
    print('currentpinCode $curentPinCode');
  }

  @override
  void initState() {
    super.initState();
    getPinCode();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
    } on PlatformException catch (e) {
      print(e);
      setState(() => confirmed = false);
      return;
    }
    if (authenticated) setState(() => confirmed = true);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Image.asset('assets/home/bg-clouds.jpg', height: height, width: width, fit: BoxFit.cover),
              Positioned(
                  top: 30,
                  right: 30,
                  child: InkWell(
                      enableFeedback: false,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        'assets/settings/btn-x.png',
                        height: 30,
                      ))),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(confirmed ? 'Please Enter New PIN' : 'Please Confirm Your PIN',
                        style: TextStyle(fontFamily: 'lapsus', fontSize: width * .08, color: Colors.white, shadows: const <Shadow>[
                          Shadow(offset: Offset(0.0, 3.0), blurRadius: 15.0, color: Colors.black),
                        ]))),
                Center(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * .1, vertical: height * 0.1),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          Image.asset('assets/pin/place-holder${pinLength >= 1 ? '-filled' : ''}.png', height: 35),
                          Image.asset('assets/pin/place-holder${pinLength >= 2 ? '-filled' : ''}.png', height: 35),
                          Image.asset('assets/pin/place-holder${pinLength >= 3 ? '-filled' : ''}.png', height: 35),
                          Image.asset('assets/pin/place-holder${pinLength == 4 ? '-filled' : ''}.png', height: 35),
                        ]))),
                Center(
                  child: PinKeyboard(
                    length: 4,
                    enableBiometric: true,
                    iconBiometricColor: Colors.blue[400],
                    onChange: (pin) {
                      setState(() => pinLength = pin.length);
                    },
                    onConfirm: (pin) {
                      print(curentPinCode);
                      switch (confirmed) {
                        case true:
                          pinCode = pin;
                          setPinCode(pinCode);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            width: width * .5,
                            backgroundColor: Colors.blueGrey,
                            content: SizedBox(
                                height: height * .07,
                                child: Center(
                                    child: Text('New Pin saved ($pinCode)!',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontFamily: 'lapsus', fontSize: 20, shadows: <Shadow>[
                                          Shadow(offset: Offset(0.0, 1.0), blurRadius: 20.0, color: Colors.black54),
                                        ])))),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            // margin: const EdgeInsets.only(bottom: 50, right: 30, left: 30),
                          ));
                          Future.delayed(const Duration(milliseconds: 1500), () => Navigator.of(context).pop());
                          break;
                        default:
                          if (curentPinCode == pin) {
                            setState(() => confirmed = true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              width: width * .8,
                              backgroundColor: Colors.blueGrey,
                              content: SizedBox(
                                  height: height * .07,
                                  child: const Center(
                                      child: Text('Pin was correct.\nNow enter your new pin.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'lapsus', fontSize: 18, shadows: <Shadow>[
                                            Shadow(offset: Offset(0.0, 1.0), blurRadius: 20.0, color: Colors.black54),
                                          ])))),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              width: width * .8,
                              backgroundColor: Colors.blueGrey,
                              content: SizedBox(
                                  height: height * .07,
                                  child: const Center(
                                      child: Text('Pin was NOT correct!\nPlease enter the correct PIN.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'lapsus', fontSize: 18, shadows: <Shadow>[
                                            Shadow(offset: Offset(0.0, 1.0), blurRadius: 20.0, color: Colors.black54),
                                          ])))),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ));
                          }
                      }
                    },
                    onBiometric: () {
                      _authenticateWithBiometrics();
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: MaterialButton(
                      child: const Text('FORGET PIN?', style: TextStyle(fontFamily: 'waytosun', fontSize: 30, decoration: TextDecoration.underline)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          width: 250,
                          backgroundColor: Colors.blueGrey,
                          content: const SizedBox(
                              height: 35, child: Center(child: Text('We have sent you an email. and Remember you may use Fingerprint.', style: TextStyle(fontFamily: 'waytosun', fontSize: 13)))),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          // margin: const EdgeInsets.only(bottom: 50, right: 30, left: 30),
                        ));
                        forgetPass();
                      },
                    ),
                  ),
                )
              ])
            ])));
  }

  forgetPass() async {
    try {
      http.Response? response = await AuthServices.sendPin();
      if (response.statusCode == 500 || response.statusCode == 404) {
        return errorSnackBar(context, 'Network connection error!');
      }

      Map responseMap = jsonDecode(response.body);
      if (response.statusCode != 200) return errorSnackBar(context, responseMap.values.first);

      return errorSnackBar(context, 'Check your email for instructions!');
    } on Exception {
      print('Time out connection 😑');
    }
  }
}
