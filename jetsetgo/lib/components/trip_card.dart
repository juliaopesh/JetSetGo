import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/trip_profile.dart';

class TripCard extends StatelessWidget {
  final String destination;
  final String dates;
  final String duration;
  final String imageName;

  const TripCard({
    required this.destination,
    required this.dates,
    required this.duration,
    required this.imageName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to TripScreen when clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripScreen(tripName: destination, tripDates: dates, tripLocation: destination,),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // Trip details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 119, 165, 205),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Dates: $dates',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    Text(
                      'Duration: $duration',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Trip image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageName,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
