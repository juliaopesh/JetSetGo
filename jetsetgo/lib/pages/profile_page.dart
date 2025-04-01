import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetsetgo/components/my_button.dart';
import 'package:jetsetgo/components/navbar.dart'; 
import 'package:jetsetgo/pages/landing_page.dart'; 

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Log Out function inside ProfilePage
  Future<void> _logOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (mounted) {
        // Clear the navigation stack and go to login page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
          (Route<dynamic> route) => false, // This removes all routes before the login page
        );
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: const Color.fromARGB(255, 245, 244, 246),
        ),
        body: Center(
          child: Text("No user logged in"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 80,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid) // Fetch the user's document based on UID
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Welcome...');
            }

            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              return const Text('Welcome User');
            }

            // Extract the user's name from Firestore
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'User'; // Default to 'User' if name is missing

            return Text(
              'Welcome $userName',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 245, 244, 246),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Center( // Centering the entire content in the body
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Info Section
              CircleAvatar(
                radius: 70,
                backgroundColor: const Color.fromARGB(255, 103, 177, 237),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Display user info from Firestore
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return Text("Username: N/A", style: TextStyle(fontSize: 18));
                  }

                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? 'N/A'; // Get user name from Firestore

                  return Text(
                    "Username: $userName", // Display the username dynamically
                    style: TextStyle(fontSize: 18),
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                "Email: ${user.email ?? 'N/A'}", // Display the email
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              // Log Out button
              MyButton(
                text: "Log Out",
                onTap: () => _logOut(context),
                color: const Color.fromARGB(255, 242, 151, 144), // Optional: matches your current red theme
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1, // Profile is now selected in the BottomNavBar
        onItemTapped: (index) {
          // Navigation logic for other items if needed
        },
      ),
    );
  }
}
