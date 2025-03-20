import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/itinerary_day_details.dart';

class ItineraryDayCard extends StatelessWidget {
  final String day;
  final String activity1;
  final String activity2;
  final VoidCallback onDelete; // Callback function for deletion

  const ItineraryDayCard({
    super.key,
    required this.day,
    required this.activity1,
    required this.activity2,
    required this.onDelete, // Receive delete function
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          // Navigate to ItineraryDayDetails when pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItineraryDayDetails(
                day: day,
                activity1: activity1,
                activity2: activity2,
              ),
            ),
          );
        },
        child: Card(
          color: const Color.fromARGB(255, 187, 238, 198), // Match original color
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: 160,
                  height: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 1, 38),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "• $activity1\n• $activity2",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: onDelete, // Call delete function
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
