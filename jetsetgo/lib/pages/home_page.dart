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
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false, // This removes the back button
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

            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.5, // constrain width
              child: Text(
                'Welcome Back $userName! Here are your upcoming trips...',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3, // wrap if needed
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
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
