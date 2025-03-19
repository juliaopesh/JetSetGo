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
    required this.onTap, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the onTap callback
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        dates,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Delete button (X icon)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onDelete, // Trigger the delete action
              ),
            ),
          ],
        ),
      ),
    );
  }
}