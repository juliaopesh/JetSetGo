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
      color: const Color(0xFF2C2C2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section (and delete button)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF3A3A3C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF2C2C2E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: const Text('Delete this day?', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'Are you sure you want to remove this itinerary day?',
                          style: TextStyle(color: Color(0xFFA1A1A3)),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true){
                      widget.onDelete(); 
                    }
                  }
                ), 
              ],
            ),
          ),

            // Activities List!!
        
            Container(
              constraints: const BoxConstraints(maxHeight: 160),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.activities.map((activity) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "• $activity",
                          style: const TextStyle(fontSize: 15, color: Colors.white70),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Edit Button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD76C5B), // Terracotta
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Edit Itinerary Day"),
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
} 
 