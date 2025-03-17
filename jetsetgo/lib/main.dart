import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'create_account.dart'; //Create Account
import 'login.dart'; //Login
import 'home_page.dart'; // Import HomePage
import 'trip_profile.dart'; //trip screen 

void main() {
  runApp(JetSetGo());
}

class JetSetGo extends StatelessWidget {
  const JetSetGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentImageIndex = 0;
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadImagesFromAssets();
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_imagePaths.isNotEmpty) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
        });
      }
    });
  }

  Future<void> _loadImagesFromAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> imagePaths = manifestMap.keys
        .where((String key) =>
            key.startsWith('assets/images/') &&
            (key.endsWith('.png') || key.endsWith('.jpg') || key.endsWith('.jpeg')))
        .toList();

    setState(() {
      _imagePaths = imagePaths;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          if (_imagePaths.isNotEmpty)
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: Image.asset(
                _imagePaths[_currentImageIndex],
                key: ValueKey<int>(_currentImageIndex),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            )
          else
            Center(child: CircularProgressIndicator()), // Show loader while images load

          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 80), // Adjust spacing from top
                Column(
                  children: [
                    Text(
                      'Your trips in one place',
                      style: TextStyle(fontSize: 20, color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 7), // Letter spacing animation
                      duration: Duration(seconds: 4),
                      builder: (context, letterSpacing, child) {
                        return Text(
                          'JETSETGO',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            letterSpacing: letterSpacing, // Animate spacing
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    SizedBox(height: 20), // More spacing
                  ],
                ),

                Spacer(), // Push buttons to bottom

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                        );
                      },
                      child: Text('Create Account'),
                    ),
                    SizedBox(height: 50), // Bottom spacing
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
