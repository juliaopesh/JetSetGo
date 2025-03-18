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
      home: LandingPage(),
    );
  }
}