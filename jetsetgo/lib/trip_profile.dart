import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/packing_list.dart';
import 'packing_list.dart';

class TripScreen extends StatelessWidget {
  final String tripName;

  const TripScreen({Key? key, required this.tripName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "My trip to...",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    tripName,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double oneThirdHeight = constraints.maxHeight / 3;
          double twoThirdsHeight = 2 * oneThirdHeight;
          double halfScreenWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              // Horizontal lines
              Positioned(top: 0, left: 0, right: 0, child: Container(height: 3, color: Colors.black)),
              Positioned(top: oneThirdHeight, left: 0, right: 0, child: Container(height: 3, color: Colors.black)),
              Positioned(top: twoThirdsHeight, left: 0, right: 0, child: Container(height: 3, color: Colors.black)),

              // Vertical line connecting first two boxes
              Positioned(top: 0, left: halfScreenWidth - 1.5, height: oneThirdHeight, child: Container(width: 3, color: Colors.black)),

              // Wallet Section
              Positioned(top: 10, left: 10, child: Text("Wallet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              Positioned(
                top: oneThirdHeight / 2 - 50,
                left: halfScreenWidth / 4,
                child: IconButton(
                  icon: Icon(Icons.account_balance_wallet, size: 100),
                  onPressed: () {},
                ),
              ),

              // Weather Section
              Positioned(top: 10, left: halfScreenWidth + 10, child: Text("Weather", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              Positioned(
                top: oneThirdHeight / 2 - 50,
                left: halfScreenWidth + (halfScreenWidth / 4),
                child: IconButton(
                  icon: Icon(Icons.wb_sunny, size: 100),
                  onPressed: () {},
                ),
              ),

              // Itinerary Title (Purple, bigger)
              Positioned(
                top: oneThirdHeight + 1,
                left: 10,
                child: Text(
                  "Itinerary",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple, letterSpacing: 2),
                ),
              ),

              // Pressable "Day X" Box (card-like)
              Positioned(
                top: oneThirdHeight + 33, // Positioned just below the "Itinerary" title, without extending past 2/3rd line
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    // Action when box is pressed
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: constraints.maxWidth * 0.1, // Make the box smaller
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4), // Adjust this to move text up inside the box
                          child: Text("Day X", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                        ),
                        Text("• Activity 1\n• Activity 2\n• Activity 3", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),

              // Section Z: Packing List
              Positioned(
                top: twoThirdsHeight + 10, // Below the 2/3rd line
                left: 10,
                child: Text(
                  "Packing List",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple, letterSpacing: 2),
                ),
              ),

              // Packing List items and button
              Positioned(
                top: twoThirdsHeight + 45, // Spacing from Packing List title
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap each CheckboxListTile with a Container to constrain the width
                    Container(
                      width: constraints.maxWidth * 0.6, // Constrain width to avoid infinite width
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          bool item1Checked = false;
                          return CheckboxListTile(
                            value: item1Checked,
                            onChanged: (bool? value) {
                              setState(() {
                                item1Checked = value ?? false;
                              });
                            },
                            title: Text("Item 1"),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 5), // Reduced space between checkboxes
                    Container(
                      width: constraints.maxWidth * 0.6, // Constrain width
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          bool item2Checked = false;
                          return CheckboxListTile(
                            value: item2Checked,
                            onChanged: (bool? value) {
                              setState(() {
                                item2Checked = value ?? false;
                              });
                            },
                            title: Text("Item 2"),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 5), // Reduced space between checkboxes
                    Container(
                      width: constraints.maxWidth * 0.6, // Constrain width
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          bool item3Checked = false;
                          return CheckboxListTile(
                            value: item3Checked,
                            onChanged: (bool? value) {
                              setState(() {
                                item3Checked = value ?? false;
                              });
                            },
                            title: Text("Item 3"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Expand button with arrow
              Positioned(
                top: twoThirdsHeight + 45,
                right: 20,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Redirect to PackingListScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PackingListScreen()),
                    );
                  },
                  icon: Icon(Icons.arrow_forward, size: 18),
                  label: Text("Expand List"),
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.purple,
                    shadowColor: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
