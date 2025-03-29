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
  final ScrollController _scrollController = ScrollController(); // ✅ Attach ScrollController

  @override
  void dispose() {
    _scrollController.dispose(); // ✅ Clean up memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Fixed Title Section**
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

            // **Scrollable Activities List**
            SizedBox(
              height: 150, // ✅ Keeps height fixed while allowing scrolling
              child: Scrollbar(
                controller: _scrollController, // ✅ Attach the controller to Scrollbar
                thumbVisibility: true, // ✅ Makes the scrollbar always visible
                child: SingleChildScrollView(
                  controller: _scrollController, // ✅ Attach the controller to the ScrollView
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Activities List
                      ...widget.activities.map((activity) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "• $activity",
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),

                      // **Edit Button (inside scrollable area)**
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity, // Makes it take the full width of the parent
                        child: ElevatedButton(
                          onPressed: widget.onEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Edit Itinerary Card"),
                        ),
                      )
                    ],
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
