import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jetsetgo/pages/create_account.dart';
import 'package:jetsetgo/pages/login_page.dart';
import 'dart:convert';

import '../components/my_button.dart'; // Import the reusable button


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentImageIndex = 0;
  List<String> _imagePaths = [];
  late Timer _timer; // Declare the Timer variable

  @override
  void initState() {
    super.initState();
    _loadImagesFromAssets();
    // Set the timer in initState
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Only update state if the widget is still in the tree
      if (mounted) {
        setState(() {
          if (_imagePaths.isNotEmpty) {
            _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
          }
        });
      }
    });
  }

  Future<void> _loadImagesFromAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> imagePaths = manifestMap.keys
        .where((String key) =>
            key.startsWith('assets/images/image_rotation/') &&
            (key.endsWith('.png') || key.endsWith('.jpg') || key.endsWith('.jpeg')))
        .toList();

    if (mounted) { // Only call setState if widget is still in the tree
      setState(() {
        _imagePaths = imagePaths;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

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
            const Center(child: CircularProgressIndicator()), // Show loader while images load

          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80), // Adjust spacing from top
                Column(
                  children: [
                    const Text(
                      'Your trips in one place',
                      style: TextStyle(fontSize: 20, color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 7), // Letter spacing animation
                      duration: const Duration(seconds: 4),
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
                    const SizedBox(height: 20), // More spacing
                  ],
                ),

                const Spacer(), // Push buttons to bottom

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(
                      text: 'Login',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      text: 'Create Account',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateAccountPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 50), // Bottom spacing
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
