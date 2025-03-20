import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String destination;
  final String dates;
  final String duration;
  final VoidCallback onDelete; // Callback for delete action
  final VoidCallback onTap; // Callback for tap action

  const TripCard({
    super.key,
    required this.destination,
    required this.dates,
    required this.duration,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), //rounded edges
        ),

        child: Container(

          width: 300, 
          padding: const EdgeInsets.all(15),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Trip Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination,
                      style: const TextStyle(
                        fontSize: 24, // Slightly bigger
                        fontWeight: FontWeight.w600, // Slightly lighter
                        fontFamily: 'Pacifico',
                        letterSpacing: 1.2, // Adds spacing between letters
                      ),
                    ),
        
                    const SizedBox(height: 5),
                    Text(
                      dates.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 44, 5, 51),
                      ),
                    ),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              //icon section
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(Icons.airplanemode_active, size: 50, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}