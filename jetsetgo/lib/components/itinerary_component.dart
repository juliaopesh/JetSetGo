import 'package:flutter/material.dart';

class ItinerarySection extends StatelessWidget {
  const ItinerarySection({super.key});

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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...["Day 1", "Day 2", "Day 3"].map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 212, 187, 230),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          day,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "• Activity 1\n• Activity 2",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}