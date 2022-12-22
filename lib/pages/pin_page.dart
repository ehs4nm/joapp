import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Pin_keyboard.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  int pinLength = 0;
  String pinCode = '';

  void loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pinCode = prefs.getString('pinCode') ?? '';
  }

  @override
  void initState() {
    super.initState();
    loadPinCode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.blue.shade300,
        body: Column(
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
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      pinLength = 0;
                    });
                  });
                  if (pinCode == pin) context.push('/home');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    width: 250,
                    backgroundColor: Colors.blueGrey,
                    content: const SizedBox(height: 25, child: Center(child: Text('Wrong pin!', style: TextStyle(fontFamily: 'waytosun', fontSize: 20)))),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    // margin: const EdgeInsets.only(bottom: 50, right: 30, left: 30),
                  ));
                },
                onBiometric: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: MaterialButton(
                child: const Text('FORGET PIN?', style: TextStyle(fontFamily: 'waytosun', fontSize: 30, decoration: TextDecoration.underline)),
                onPressed: () => setState(() {
                  context.push('/login');
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
