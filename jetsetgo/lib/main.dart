import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/firebase_options.dart';
import 'package:jetsetgo/pages/landing_page.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(JetSetGo());
}

class JetSetGo extends StatelessWidget {
  const JetSetGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        cardColor: const Color(0xFF2C2C2E),
        primaryColor: const Color(0xFFFF453A),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: 'Inter',
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C1C1E),
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 24, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: LandingPage(),
    );
  }
}