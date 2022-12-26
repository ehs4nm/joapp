import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

/// App widget class.
class IntroApp extends StatelessWidget {
  IntroApp({Key? key}) : super(key: key);

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setIntroIsWatched() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool('introIsWatched', true).then((bool success) {
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Intro',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Builder(
            builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: introWidget(context),
                )));
  }

  Material introWidget(BuildContext context) {
    return Material(
        // type: MaterialType.transparency,
        child: Stack(alignment: Alignment.topCenter, children: [
      // Image.asset('assets/home/bg-home-no-windfan.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
      SizedBox(
        child: Stack(children: [
          Center(child: Image.asset('assets/home/bg-try-again.png', width: MediaQuery.of(context).size.width, fit: BoxFit.cover)),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60.0, 130, 60, 50),
              child: Column(
                children: const [
                  Text('Important information for parents', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  Text(
                      textAlign: TextAlign.justify,
                      '\nSign up for JooJ Bank app has to be done by parents. Also adding or withdrawing  pretending money has to be done by parents supervision by using their assigned four digit pin or fingerprint verification. The money that kids earn from their parents for doing chores are just pretending money but at the same time since we think JooJ Bank can be a very good and fun tools for kids to learn how to save and spend their money, therefore we decided to make transactions to be only verified by parents first.',
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ]),
      ),
      Positioned(
        bottom: 50,
        child: TextButton(
            onPressed: () {
              setIntroIsWatched();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NewHomePage()),
                // MaterialPageRoute(builder: (_) => const AuthGate()),
              );
            },
            child: Image.asset('assets/home/btn-ok.png', width: 80)),
      )
    ]));
  }
}
