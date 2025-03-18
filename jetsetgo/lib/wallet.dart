import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
        backgroundColor: const Color.fromARGB(255, 119, 165, 205),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Title
            Text(
              'Your Wallet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 119, 165, 205),
              ),
            ),
            SizedBox(height: 20),

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
    );
  }
}

class WalletCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;

  const WalletCard({
    required this.title,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: const Color.fromARGB(255, 119, 165, 205)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Date: $date',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
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
