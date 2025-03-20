import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItinerarySection extends StatelessWidget {
  const ItinerarySection({super.key});

  // Function to add a new day with activities
  Future<void> _addNewDay(BuildContext context, String tripId, String itineraryId) async {
    final user = FirebaseAuth.instance.currentUser!;

    // Show a dialog to input new activities
    final TextEditingController activity1Controller = TextEditingController();
    final TextEditingController activity2Controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Day"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: activity1Controller,
                decoration: const InputDecoration(hintText: "Activity 1"),
              ),
              TextField(
                controller: activity2Controller,
                decoration: const InputDecoration(hintText: "Activity 2"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Get the new activities
                final activity1 = activity1Controller.text.trim();
                final activity2 = activity2Controller.text.trim();

                if (activity1.isNotEmpty || activity2.isNotEmpty) {
                  // Determine the next day number (e.g., day1, day2, etc.)
                  final daysSnapshot = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('trip')
                      .doc(tripId)
                      .collection('tripItinerary')
                      .doc(itineraryId)
                      .collection('day1') // Check the day1 subcollection
                      .get();

                  final nextDayNumber = daysSnapshot.docs.length + 1; // Increment day number
                  final nextDayId = 'day$nextDayNumber'; // e.g., day2, day3, etc.

                  // Add the new day to Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('trip')
                      .doc(tripId)
                      .collection('tripItinerary')
                      .doc(itineraryId)
                      .collection(nextDayId) // Use the next day ID
                      .add({
                    'Activity1': activity1,
                    'Activity2': activity2,
                  });

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
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
      builder: (context, tripSnapshot) {
        if (tripSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tripSnapshot.hasError) {
          return Center(child: Text('Error: ${tripSnapshot.error}'));
        }

        if (!tripSnapshot.hasData || tripSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No trips found.'));
        }

        // Extract the first trip document ID (you can modify this logic as needed)
        final tripId = tripSnapshot.data!.docs.first.id;

        // Fetch the itinerary data for the first trip
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('trip')
              .doc(tripId) // Use the trip document ID
              .collection('tripItinerary') // Access the tripItinerary subcollection
              .snapshots(),
          builder: (context, itinerarySnapshot) {
            if (itinerarySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (itinerarySnapshot.hasError) {
              return Center(child: Text('Error: ${itinerarySnapshot.error}'));
            }

            if (!itinerarySnapshot.hasData || itinerarySnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No itinerary found.'));
            }

            // Extract the first itinerary document ID
            final itineraryId = itinerarySnapshot.data!.docs.first.id;

            // Fetch all day subcollections under the itinerary
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('trip')
                  .doc(tripId)
                  .collection('tripItinerary')
                  .doc(itineraryId) // Use the itinerary document ID
                  .collection('day1') // Fetch all day subcollections
                  .snapshots(),
              builder: (context, daySnapshot) {
                if (daySnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (daySnapshot.hasError) {
                  return Center(child: Text('Error: ${daySnapshot.error}'));
                }

                if (!daySnapshot.hasData || daySnapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No activities found for this day.'));
                }

                // Group activities by day
                final Map<String, List<String>> daysMap = {};
                for (final doc in daySnapshot.data!.docs) {
                  final dayId = doc.reference.parent.id; // e.g., day1, day2, etc.
                  final activity1 = doc['Activity1'] as String? ?? "No activity";
                  final activity2 = doc['Activity2'] as String? ?? "No activity";

                  if (!daysMap.containsKey(dayId)) {
                    daysMap[dayId] = [];
                  }
                  daysMap[dayId]!.addAll([activity1, activity2]);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Itinerary",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 28, 1, 38),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Display cards for each day
                          ...daysMap.entries.map((entry) {
                            final dayId = entry.key;
                            final activities = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Card(
                                elevation: 5, // Match the elevation of TripCard
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Match the border radius
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.pink[100], // Light pink background
                                    borderRadius: BorderRadius.circular(10), // Match the border radius
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        dayId, // e.g., day1, day2, etc.
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: activities.map((activity) {
                                          return Text(
                                            "• $activity",
                                            style: const TextStyle(fontSize: 12),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          // Add a plus icon to add a new day
                          GestureDetector(
                            onTap: () {
                              _addNewDay(context, tripId, itineraryId);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.pink[100], // Light pink background
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}