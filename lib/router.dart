import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jooj_bank/pages/login_page.dart';

import 'pages/register_page.dart';
import 'pages/home_page.dart';

import 'pages/profile_page.dart';
import 'pages/select_child_page.dart';
import 'pages/settings_page.dart';
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
            return const NewHomePage();
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
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsPage();
          },
        ),
        // GoRoute(
        //   path: 'child/:id',
        //   name: 'child',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return ChildPage(
        //       id: state.params["id"]!,
        //     );
        //   },
        // ),
        GoRoute(
          path: 'auth',
          builder: (BuildContext context, GoRouterState state) {
            return const NewHomePage();
          },
        ),

        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfilePage();
          },
        ),

        GoRoute(
          path: 'history',
          builder: (BuildContext context, GoRouterState state) {
            return const SelectChildPage();
          },
        ),

        GoRoute(
          path: 'contact',
          builder: (BuildContext context, GoRouterState state) {
            return const NewHomePage();
          },
        ),

        GoRoute(
          path: 'add-child',
          builder: (BuildContext context, GoRouterState state) {
            return const NewHomePage();
          },
        ),

        GoRoute(
          path: 'select-child',
          builder: (BuildContext context, GoRouterState state) {
            return const SelectChildPage();
          },
        ),

        GoRoute(
          path: 'logout',
          builder: (BuildContext context, GoRouterState state) {
            return const NewHomePage();
          },
        ),

        // GoRoute(
        //   path: 'intro',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const IntroApp();
        //   },
        // ),
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
