import 'package:flutter/material.dart';

class ItineraryDayDetails extends StatelessWidget {
  final String day;
  final String activity1;
  final String activity2;

  const ItineraryDayDetails({
    super.key,
    required this.day,
    required this.activity1,
    required this.activity2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          day,
          style: TextStyle(
            fontSize: 28, // Match home page title size
            color: Colors.black, // Match home page title color
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 187, 238, 198),
        //backgroundColor: const Color.fromARGB(255, 245, 244, 246), // Match home page AppBar color
        toolbarHeight: 80, // Match home page AppBar height
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activities for $day",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• $activity1",
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "• $activity2",
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
