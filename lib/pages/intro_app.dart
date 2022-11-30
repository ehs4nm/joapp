import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_gate.dart';

/// App widget class.
class IntroApp extends StatelessWidget {
  final SharedPreferences prefs;
  final String boolKey;

  const IntroApp({Key? key, required this.prefs, required this.boolKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    prefs.setBool(boolKey, false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntroViews',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: false,
          showBackButton: false,
          onTapDoneButton: () {
            // Use Navigator.pushReplacement if you want to dispose the latest route
            // so the user will not be able to slide back to the Intro Views.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AuthGate()),
            );
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

final pages = [
  PageViewModel(
    pageColor: const Color(0xFF03A9F4),
    bubble: Image.asset('assets/air-hostess.png'),
    body: const Text(
      'Hassle-free  booking  of  flight  tickets  with  full  refund  on  cancellation',
    ),
    title: const Text(
      'Flights',
    ),
    titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    mainImage: Image.asset(
      'assets/airplane.png',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
  ),
  PageViewModel(
    pageColor: const Color(0xFF8BC34A),
    iconImageAssetPath: 'assets/waiter.png',
    body: const Text(
      'We  work  for  the  comfort ,  enjoy  your  stay  at  our  beautiful  hotels',
    ),
    title: const Text('Hotels'),
    mainImage: Image.asset(
      'assets/hotel.png',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
  ),
  PageViewModel(
    pageBackground: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          stops: [0.0, 1.0],
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          tileMode: TileMode.repeated,
          colors: [
            Colors.orange,
            Colors.pinkAccent,
          ],
        ),
      ),
    ),
    iconImageAssetPath: 'assets/taxi-driver.png',
    body: const Text(
      'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
    ),
    title: const Text('Cabs'),
    mainImage: Image.asset(
      'assets/taxi.png',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
    titleTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
    bodyTextStyle: const TextStyle(fontFamily: 'MyFont', color: Colors.white),
  ),
];
