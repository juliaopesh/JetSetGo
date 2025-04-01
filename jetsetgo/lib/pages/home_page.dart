import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetsetgo/components/trip_list.dart';
import 'package:jetsetgo/pages/add_trip.dart';
import 'package:jetsetgo/components/add_button.dart'; // Import the AddButton component
import 'package:jetsetgo/components/navbar.dart'; // Import your BottomNavBar component

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
                fontSize: 24, // Large font size
                color: Colors.black,
              ),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(255, 245, 244, 246),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of trips
            const Expanded(child: TripList()), 
          ],
        ),
      ),
      // Add a circular "Add Trip" button at the bottom right
      floatingActionButton: AddButton(
        label: 'Add Trip',
        onPressed: () {
          // Navigate to the AddTrip screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTrip()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position at bottom right

      // Bottom Navigation Bar added below the floating action button
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0, // Default selected index, change as necessary
        onItemTapped: (index) {
         
        },
      ),
    );
  }
}
