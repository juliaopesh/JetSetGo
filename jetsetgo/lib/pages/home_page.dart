import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetsetgo/components/logout_button.dart';
import 'package:jetsetgo/components/trip_list.dart';
import 'package:jetsetgo/components/wallet_button.dart';
import 'package:jetsetgo/pages/add_trip.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: Color.fromARGB(255, 67, 44, 84),
              ),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 212, 187, 230),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of trips
            const Expanded(child: TripList()), // ✅ Uses TripList component

            const SizedBox(height: 20),

            // "Add Trip" Button (less wide)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the AddTrip screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddTrip()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), // Increase button height
                    backgroundColor: const Color.fromARGB(255, 212, 187, 230), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Add Trip',
                    style: TextStyle(
                      fontSize: 18, // Larger font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Wallet Button
            const Center(child: WalletButton()), // ✅ Uses WalletButton component
          ],
        ),
      ),
    );
  }
}