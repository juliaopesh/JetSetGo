import 'package:flutter/material.dart';
import 'package:jetsetgo/components/itinerary_daycard.dart';

class ItinerarySection extends StatefulWidget {
  const ItinerarySection({super.key});

  @override
  _ItinerarySectionState createState() => _ItinerarySectionState();
}

class _ItinerarySectionState extends State<ItinerarySection> {
  List<Map<String, String>> itineraryDays = [
    {"day": "Day 1", "activity1": "Visit Museum", "activity2": "Lunch at Local Cafe"},
    {"day": "Day 2", "activity1": "Hiking Trail", "activity2": "Dinner by the Beach"},
    {"day": "Day 3", "activity1": "Shopping at Market", "activity2": "Sunset Cruise"},
  ];

  // Function to add a new itinerary day
  void _addNewItineraryDay(String day, String activity1, String activity2) {
    setState(() {
      itineraryDays.add({
        "day": day,
        "activity1": activity1,
        "activity2": activity2,
      });
    });
  }

  // Function to remove an itinerary day
  void _deleteItineraryDay(int index) {
    setState(() {
      itineraryDays.removeAt(index);
    });
  }

  // Dialog for adding a new itinerary day
  void _showAddDayDialog(BuildContext context) {
    TextEditingController dayController = TextEditingController();
    TextEditingController activity1Controller = TextEditingController();
    TextEditingController activity2Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Itinerary Day"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: dayController, decoration: const InputDecoration(labelText: "Day Number (e.g., Day 4)")),
              TextField(controller: activity1Controller, decoration: const InputDecoration(labelText: "Activity 1")),
              TextField(controller: activity2Controller, decoration: const InputDecoration(labelText: "Activity 2")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (dayController.text.isNotEmpty &&
                    activity1Controller.text.isNotEmpty &&
                    activity2Controller.text.isNotEmpty) {
                  _addNewItineraryDay(dayController.text, activity1Controller.text, activity2Controller.text);
                  Navigator.pop(context);
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
              ...itineraryDays.asMap().entries.map((entry) {
                int index = entry.key;
                var day = entry.value;
                return ItineraryDayCard(
                  day: day["day"]!,
                  activity1: day["activity1"]!,
                  activity2: day["activity2"]!,
                  onDelete: () => _deleteItineraryDay(index), // Pass delete function
                );
              }).toList(),
              // Plus button right after the last itinerary card
              IconButton(
                icon: const Icon(Icons.add_circle, color: const Color.fromARGB(255, 187, 238, 198), size: 40),
                onPressed: () => _showAddDayDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
