import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/pages/contact_page.dart';
import 'package:jooj_bank/pages/intro_app.dart';
import 'package:jooj_bank/pages/login_page.dart';
import 'package:jooj_bank/pages/pin_page.dart';
import 'package:jooj_bank/pages/set_pin_page.dart';

import 'pages/register_page.dart';
import 'pages/home_page.dart';

import 'pages/splash.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),
        GoRoute(
          path: 'intro',
          name: 'intro',
          builder: (BuildContext context, GoRouterState state) {
            return const IntroApp();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'pin',
          builder: (BuildContext context, GoRouterState state) {
            return const PinPage(
              type: 'add',
            );
          },
        ),
        GoRoute(
          path: 'set-pin',
          builder: (BuildContext context, GoRouterState state) {
            return const SetPinPage();
          },
        ),
        GoRoute(
          path: 'contact',
          builder: (BuildContext context, GoRouterState state) {
            return const ContactPage();
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
