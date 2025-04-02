import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String destination;
  final String dates;
  final String duration;
  final VoidCallback onTap; // Callback for tap action

  const TripCard({
    super.key,
    required this.destination,
    required this.dates,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        color: const Color(0xFF2C2C2E), // Dark card background
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), //rounded edges\
          side: const BorderSide(color: Color(0xFF3A3A3C)), //subtle border color 
        ),

        child: Container(

          width: 300, 
          padding: const EdgeInsets.all(16),

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
                        fontSize: 22, // Slightly bigger
                        fontWeight: FontWeight.w800, // Slightly lighter
                        color: Colors.white,
                      ),
                    ),
        
                    const SizedBox(height: 6),
                    Text(
                      dates.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA1A1A3),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFA1A1A3),
                      ),
                    ),
                  ],
                ),
              ),


              //icon section
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withAlpha((0.08 * 255).round()), // subtle icon bg : ~20 alpha
                  border: Border.all(color: Colors.white12),    //,width: 2),
                ),
                child: Icon(
                  Icons.airplanemode_active, 
                  size: 32, 
                  color: Color(0xFFD76C5B), // soft red accent
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}