import 'package:flutter/material.dart';
import 'package:jetsetgo/components/add_button.dart'; // Import the AddButton component

class WalletPage extends StatelessWidget {
  final String tripName; // Accept trip name


  WalletPage({super.key, required this.tripName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Match home page background
      appBar: AppBar(
        title: Text(
          '$tripName - Wallet',
          style: TextStyle(
            fontSize: 28, // Match home page title size
            fontWeight: FontWeight.bold, 
          ),
        ),
        backgroundColor: Colors.orange[100],
        //backgroundColor: const Color.fromARGB(255, 245, 244, 246), // Match home page AppBar color
        toolbarHeight: 80, // Match home page AppBar height
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Wallet items (cards)
            Expanded(
              child: ListView(
                children: [
                  WalletCard(
                    title: 'Boarding Pass: ABC123',
                    date: 'Sept 20, 2025',
                    icon: Icons.airplanemode_active,
                  ),
                  WalletCard(
                    title: 'Museum Ticket: XYZ987',
                    date: 'Sept 21, 2025',
                    icon: Icons.museum,
                  ),
                  WalletCard(
                    title: 'Concert Ticket: DEF456',
                    date: 'Oct 10, 2025',
                    icon: Icons.music_note,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Add document button 
      floatingActionButton: SizedBox(
        width: 180,  
        height: 60, 
        child: FloatingActionButton.extended(
          backgroundColor: Colors.orange[100], 
          onPressed: () {
            // Add functionality to handle adding a document
          },
          label: Text(
            'Add Document',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),  // Bigger font
          ),
          icon: Icon(Icons.add, size: 28),  // Bigger icon
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,  // Center it at bottom

    );
  }
}

class WalletCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;

  const WalletCard({super.key, 
    required this.title,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: const Color.fromARGB(255, 245, 244, 246), // Match home page AppBar color
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color.fromARGB(255, 212, 187, 230), // Match home page button color
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 1, 38), // Match home page text color
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Date: $date',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54, // Match home page secondary text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}