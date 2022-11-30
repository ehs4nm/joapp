import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/firebase_options.dart';
import 'router.dart';

bool shouldUseFirebaseEmulator = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyD5h_caVo8rRga-UMKR621VzfuuJ5KDk6k',
        appId: '1:163702977514:web:93c2b0446b9b3cd2f57893',
        messagingSenderId: '163702977514',
        projectId: 'jobank-bda58',
        authDomain: 'jobank-bda58.firebaseapp.com',
        storageBucket: 'jobank-bda58.appspot.com',
        databaseURL: '',
        measurementId: '',
      ),
    );
  }

  if (shouldUseFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  // globalAuthenticator = await PinLock.baseAuthenticator('1');

  runApp(const RouterApp());
}
