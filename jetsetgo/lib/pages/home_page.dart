import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetsetgo/components/logout_button.dart';
import 'package:jetsetgo/components/trip_list.dart';
import 'package:jetsetgo/pages/add_trip.dart';
import 'package:jetsetgo/pages/wallet.dart'; // Import the WalletPage

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 80,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid) // Fetch the user's document
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Welcome...'); // Placeholder while loading
            }

            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              return const Text('Welcome User'); // Fallback if data is missing
            }

            // Extract the user's name
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userName = userData['name'] ?? 'User'; // Default to 'User' if name is missing

            return Text(
              'Welcome $userName! Here are your upcoming trips...',
              style: const TextStyle(
                fontSize: 28, // Large font size
                color: Colors.black,
              ),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 245, 244, 246),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of trips
                const Expanded(child: TripList()), // ✅ Uses TripList component
              ],
            ),
          ),
          // Wallet Image (positioned in the bottom-left corner)
          Positioned(
            left: 16, // Adjust the position as needed
            bottom: 16, // Adjust the position as needed
            child: GestureDetector(
              onTap: () {
                // Navigate to the WalletPage when the image is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WalletPage()),
                );
              },
              child: Image.asset(
                'assets/images/wallet2.png', // Path to your wallet image
                width: 230, // Set the width
                height: 230, // Set the height
              ),
            ),
          ),
        ],
      ),
      // Add a circular "Add Trip" button at the bottom right
      floatingActionButton: SizedBox(
        width: 80, // Set the width of the button
        height: 80, // Set the height of the button
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to the AddTrip screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTrip()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 212, 187, 230), // Button color
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 36, // Larger icon size
              ),
              Text(
                'Add Trip',
                style: TextStyle(
                  fontSize: 12, // Smaller font size
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position at bottom right
    );
  }
}