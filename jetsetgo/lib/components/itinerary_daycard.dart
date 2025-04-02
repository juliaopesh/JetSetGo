import 'package:flutter/material.dart';

class ItineraryDayCard extends StatefulWidget {
  final String day;
  final List<String> activities;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ItineraryDayCard({
    super.key,
    required this.day,
    required this.activities,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  _ItineraryDayCardState createState() => _ItineraryDayCardState();
}

class _ItineraryDayCardState extends State<ItineraryDayCard> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 187, 238, 198),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.day,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),

            // Scrollable activities section
            SizedBox(
              height: 150,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.activities.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "• $activity",
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Button pinned at the bottom
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 181, 234, 193),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Edit Itinerary Card"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
