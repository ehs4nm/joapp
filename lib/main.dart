import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_lock/pin_lock.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth_app.dart';
import 'intro_app.dart';
import 'firebase_options.dart';

bool shouldUseFirebaseEmulator = true;
late final Authenticator globalAuthenticator;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        appId: '1:163702977514:web:93c2b0446b9b3cd2f57893',
        messagingSenderId: '448618578101',
        projectId: 'react-native-firebase-testing',
        authDomain: 'react-native-firebase-testing.firebaseapp.com',
        databaseURL: 'https://react-native-firebase-testing.firebaseio.com',
        storageBucket: 'react-native-firebase-testing.appspot.com',
        measurementId: 'G-F79DJ0VFGS',
      ),
    );
  }

  if (shouldUseFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  globalAuthenticator = await PinLock.baseAuthenticator('1');
  var prefs = await SharedPreferences.getInstance();
  var boolKey = 'isFirstTime';
  var isFirstTime = prefs.getBool(boolKey) ?? true;

  runApp(
      isFirstTime ? IntroApp(prefs: prefs, boolKey: boolKey) : const AuthApp());
}
