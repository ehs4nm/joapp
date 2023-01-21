import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jooj_bank/providers/children_provider.dart';
import 'package:provider/provider.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChildrenProvider(),
        ),
      ],

      child: const RouterApp(),
      // dispose: (context, DatabaseHandler db)=> db.close(),
    ));
  });
}
