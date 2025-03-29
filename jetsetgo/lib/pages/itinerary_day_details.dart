import 'package:flutter/material.dart';

class ItineraryDayDetails extends StatelessWidget {
  final String day;
  final List<String> activities; // Change from String to List<String>

  const ItineraryDayDetails({
    super.key,
    required this.day,
    required this.activities, // Accept a list of activities
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          day,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 187, 238, 198),
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 28, 1, 38),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enable side-by-side scrolling
                  child: Row(
                    children: activities
                        .map((activity) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                activity,
                                style: const TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
