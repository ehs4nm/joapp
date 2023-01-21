import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/pages/waiting_rfid_add.dart';
import 'package:jooj_bank/pages/waiting_rfid_spend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import '../models/Pin_keyboard.dart';

class PinPage extends StatefulWidget {
  final String type;
  const PinPage({super.key, required this.type});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  int pinLength = 0;
  String pinCode = '';
  bool touchId = false;

  void loadPinCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pinCode = prefs.getString('pinCode') ?? '1234';
    touchId = prefs.getBool('touchId') ?? false;
    print('$pinCode  , $touchId');
  }

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
        );

    loadPinCode();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'yes' : 'no';
    setState(() {
      _authorized = message;
      if (_authorized == 'yes') {
        // Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget.type == 'add' ? const WaitingRfidAddPage(muted: false) : WaitingRfidSpendPage(muted: false)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Image.asset('assets/home/bg-clouds.jpg', height: height, fit: BoxFit.cover),
            Stack(children: [
              if (_supportState == _SupportState.unknown)
                const CircularProgressIndicator()
              else if (_supportState == _SupportState.supported)
                const Text('') //This device is supported
              else
                const Text(''), //This device is not supported
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 20.0),
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
                      enableBiometric: touchId,
                      // && _supportState == _SupportState.supported,
                      iconBiometricColor: Colors.blue[400],
                      onChange: (pin) {
                        setState(() {
                          pinLength = pin.length;
                        });
                      },
                      onConfirm: (pin) {
                        if (pinCode == pin) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget.type == 'add' ? const WaitingRfidAddPage(muted: false) : WaitingRfidSpendPage(muted: false)));
                          // Navigator.of(context, rootNavigator: true).pop();

                        } else {
                          Future.delayed(const Duration(milliseconds: 200), () {
                            setState(() {
                              pinLength = 0;
                            });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            width: 250,
                            backgroundColor: Colors.blueGrey,
                            content: const SizedBox(height: 25, child: Center(child: Text('Wrong pin!', style: TextStyle(fontFamily: 'waytosun', fontSize: 20)))),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            // margin: const EdgeInsets.only(bottom: 50, right: 30, left: 30),
                          ));
                        }
                      },
                      onBiometric: () {
                        _authenticateWithBiometrics();
                        print(pinCode);
                      },
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
            ]),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
