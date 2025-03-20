import 'package:flutter/material.dart';
import 'package:jetsetgo/components/add_button.dart'; // Import the AddButton component

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Match home page background
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(
            fontSize: 28, // Match home page title size
            color: Colors.black, // Match home page title color
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
      // Add a circular "Add Document" button at the bottom right
      floatingActionButton: AddButton(
        label: 'Add Document',
        onPressed: () {
          // Add functionality to handle adding a document
          // For example, navigate to a new screen or show a dialog
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position at bottom right
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