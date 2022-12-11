import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jojo/pages/home.dart';
import 'package:jojo/providers/children_provider.dart';
import 'package:provider/provider.dart';

import 'pages/auth_gate.dart';
import 'pages/child.dart';
import 'pages/intro_app.dart';
import 'pages/profile_page.dart';
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
            return ChangeNotifierProvider(
              create: (context) => ChildrenProvider(),
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          path: 'auth',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthApp();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return ChangeNotifierProvider(
              create: (context) => ChildrenProvider(),
              child: const SettingsPage(),
            );
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
            return const HomePage();
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
            return const HomePage();
          },
        ),

        GoRoute(
          path: 'contact',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),

        GoRoute(
          path: 'add-child',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
        ),

        GoRoute(
          path: 'logout',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
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
