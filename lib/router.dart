import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jojo/pages/home.dart';
import 'package:jojo/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth_gate.dart';
import 'pages/intro_app.dart';

shouldStartIntro() async {
  var prefs = await SharedPreferences.getInstance();
  var boolKey = 'isFirstTime';
  var isFirstTime = prefs.getBool(boolKey) ?? true;
  Map introConditions = {
    prefs: prefs,
    boolKey: boolKey,
    isFirstTime: isFirstTime
  };
  return introConditions;
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthApp();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const Settings();
          },
        ),
        GoRoute(
          path: 'auth',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: 'intro',
          builder: (BuildContext context, GoRouterState state) {
            var introConditions = shouldStartIntro();
            return IntroApp(
                prefs: introConditions['prefs'],
                boolKey: introConditions['boolKey']);
          },
        ),
      ],
    ),
  ],
);

class RouterApp extends StatelessWidget {
  const RouterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
