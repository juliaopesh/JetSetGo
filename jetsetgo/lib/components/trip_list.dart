import 'package:flutter/material.dart';
import 'package:jetsetgo/components/trip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetsetgo/pages/trip_profile.dart'; // Import the TripScreen

class TripList extends StatelessWidget {
  const TripList({super.key});

  // Function to delete a trip
  Future<void> _deleteTrip(String tripId, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('trip')
          .doc(tripId)
          .delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip deleted successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trip: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Fetch data for the current user
          .collection('trip') // Access the trip subcollection
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No trips found.'));
        }

        // Extract trip documents from Firestore
        final trips = snapshot.data!.docs;

        return ListView(
          children: trips.map((trip) {
            // Fetch the nested tripID document for each trip
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('trip')
                  .doc(trip.id) // Use the trip document ID
                  .collection('tripID') // Access the tripID subcollection
                  .snapshots(),
              builder: (context, tripIdSnapshot) {
                if (tripIdSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tripIdSnapshot.hasError) {
                  return Center(child: Text('Error: ${tripIdSnapshot.error}'));
                }

                if (!tripIdSnapshot.hasData || tripIdSnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No trip details found.'));
                }

                // Extract trip details from the tripID document
                final tripDetails = tripIdSnapshot.data!.docs.first.data() as Map<String, dynamic>;

                return TripCard(
                  destination: '${tripDetails['City']}, ${tripDetails['Country']}',
                  dates: '${tripDetails['Month']} ${tripDetails['DateLeaving']} - ${tripDetails['DateReturning']}, 2025',
                  duration: '${tripDetails['Duration']} days',
                  onDelete: () => _deleteTrip(trip.id, context), // Pass the delete function
                  onTap: () {
                    // Navigate to the TripScreen with trip details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripScreen(
                          tripName: '${tripDetails['City']}, ${tripDetails['Country']}',
                          tripDates: '${tripDetails['Month']} ${tripDetails['DateLeaving']} - ${tripDetails['DateReturning']}, 2025',
                          tripLocation: '${tripDetails['City']}, ${tripDetails['Country']}',
                          tripId: trip.id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}