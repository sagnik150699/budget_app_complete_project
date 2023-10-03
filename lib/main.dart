import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';

import 'responsive_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDTqxkfEwFAAqDzmRlMJ6BT-YVDdnsu6yw",
          authDomain: "budget-app-3eb54.firebaseapp.com",
          projectId: "budget-app-3eb54",
          storageBucket: "budget-app-3eb54.appspot.com",
          messagingSenderId: "582942096598",
          appId: "1:582942096598:web:fe5d329e7037106a821d77",
          measurementId: "G-Q2LS71J1N6"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Budget App",
      //  theme: ThemeData(useMaterial3: true),
      home: ResponsiveHandler(),
    );
  }
}
