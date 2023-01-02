import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Pin_keyboard.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  int pinLength = 0;
  late String pinCode;

  void setPinCode(pinCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pinCode', pinCode);
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
          Image.asset('assets/home/bg-clouds.png', height: height, width: width, fit: BoxFit.cover),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/pin/place-holder${pinLength >= 1 ? '-filled' : ''}.png', height: 35),
                      Image.asset('assets/pin/place-holder${pinLength >= 2 ? '-filled' : ''}.png', height: 35),
                      Image.asset('assets/pin/place-holder${pinLength >= 3 ? '-filled' : ''}.png', height: 35),
                      Image.asset('assets/pin/place-holder${pinLength == 4 ? '-filled' : ''}.png', height: 35),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Text('ENTER YOUR PIN', style: TextStyle(fontFamily: 'waytosun', fontSize: 30)),
              ),
              Center(
                child: PinKeyboard(
                  length: 4,
                  enableBiometric: true,
                  iconBiometricColor: Colors.blue[400],
                  onChange: (pin) {
                    setState(() {
                      pinLength = pin.length;
                    });
                  },
                  onConfirm: (pin) {
                    pinCode = pin;

                    // if (pinCode == pin) context.push('/home');
                  },
                  onBiometric: () {
                    print(3);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: MaterialButton(
                  child: const Text('SAVE IT', style: TextStyle(fontFamily: 'waytosun', fontSize: 30, decoration: TextDecoration.underline)),
                  onPressed: () {
                    setPinCode(pinCode);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      width: 250,
                      backgroundColor: Colors.blueGrey,
                      content: SizedBox(height: 25, child: Center(child: Text('Pin ($pinCode) saved!', style: const TextStyle(fontFamily: 'waytosun', fontSize: 20)))),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      // margin: const EdgeInsets.only(bottom: 50, right: 30, left: 30),
                    ));
                    Future.delayed(
                      const Duration(seconds: 2),
                      () => Navigator.of(context).pop(),
                    );
                  },
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
