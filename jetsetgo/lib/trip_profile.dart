import 'package:flutter/material.dart';
import 'packing_list.dart';
import 'wallet.dart';

class TripScreen extends StatefulWidget {
  final String tripName;
  final String tripDates;

  const TripScreen({Key? key, required this.tripName, required this.tripDates}) : super(key: key);

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  // List to hold the itinerary days dynamically
  List<String> itineraryDays = ["Day 1", "Day 2", "Day 3"];
  List<String> detailedActivities = [
    "• Activity 1\n• Activity 2\n• Activity 3",
    "• Activity 4\n• Activity 5\n• Activity 6",
    "• Activity 7\n• Activity 8\n• Activity 9"
  ];

  void _showDayDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(itineraryDays[index]),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detailedActivities[index]),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add new activity for this day
                  setState(() {
                    detailedActivities[index] += "\n• New Activity";
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Add Activity"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Delete activity for this day
                  setState(() {
                    detailedActivities[index] = "• No activities yet";
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Delete Activity"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.tripName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 119, 165, 205),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // scrolling!!!
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text("My trip to...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                    SizedBox(height: 5),
                    Text(
                      widget.tripName.toUpperCase(),
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Dates: ${widget.tripDates}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Wallet & Weather Section
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the WalletPage when clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WalletPage()),
                        );
                      },
                      child: _buildFeatureBox(Icons.account_balance_wallet, "Wallet"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: _buildFeatureBox(Icons.wb_sunny, "Weather")),
                ],
              ),
              SizedBox(height: 20),

              // Itinerary Section
              Text("Itinerary", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...itineraryDays.map((day) {
                      int index = itineraryDays.indexOf(day);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: () => _showDayDetails(index), // Show day details on tap
                          child: _buildDayCard(day, index),
                        ),
                      );
                    }).toList(),
                    SizedBox(width: 10),
                    _buildAddButton(),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Packing List Section
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Packing List",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the PackingListScreen when clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PackingListScreen(tripTitle: widget.tripName)),
                            );
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text("Expand List"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.pink, thickness: 2),
                    Column(
                      children: [
                        _buildPackingItem("Item 1"),
                        _buildPackingItem("Item 2"),
                        _buildPackingItem("Item 3"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // space at bottom to avoid cutting content
            ],
          ),
        ),
      ),
    );
  }

  // Feature Box (Wallet & Weather)
  Widget _buildFeatureBox(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Icon(icon, size: 60),
        ],
      ),
    );
  }

  // Itinerary Day Card
  Widget _buildDayCard(String day, int index) {
    return Container(
      padding: EdgeInsets.all(15),
      width: 120, // Wider day card
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(day, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
          SizedBox(height: 5),
          Text("• Activity 1\n• Activity 2", style: TextStyle(fontSize: 12)),
          // You can replace these with dynamic content later
        ],
      ),
    );
  }

  // Add Button for Itinerary
  Widget _buildAddButton() {
    return GestureDetector(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 3),
          shape: BoxShape.circle,
        ),
        child: Center(child: Icon(Icons.add, color: Colors.purple, size: 24)),
      ),
    );
  }

  // Packing List Item
  Widget _buildPackingItem(String item) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Text(item, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
