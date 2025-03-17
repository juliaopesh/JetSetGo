import 'package:flutter/material.dart';

import 'trip_profile.dart'; // Import TripScreen

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JetSetGo'),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Trips Section
            Text(
              'Upcoming Trips',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 20),

            // List of trips (each in a card with an image)
            Expanded(
              child: ListView(
                children: [
                  TripCard(
                    destination: 'Barcelona, Spain',
                    dates: 'Sept 20 - 27, 2025',
                    duration: '7 days',
                    imageName: 'assets/images/barcelona_widget.jpg', 
                  ),
                  TripCard(
                    destination: 'Tokyo, Japan',
                    dates: 'Oct 5 - 15, 2025',
                    duration: '10 days',
                   imageName: 'assets/images/tokyo_widget.jpeg', 
                  ),
                  TripCard(
                    destination: 'Paris, France',
                    dates: 'Nov 1 - 7, 2025',
                    duration: '6 days',
                    imageName: 'assets/images/paris_widget.jpg', // Name of the image in your assets
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Button to navigate to Wallet page
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Wallet page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900], 
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text(
                  'Go to Wallet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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

class TripCard extends StatelessWidget {
  final String destination;
  final String dates;
  final String duration;
  final String imageName;

  const TripCard({
    required this.destination,
    required this.dates,
    required this.duration,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        //when clicked, navigate to trip screen 
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => TripScreen(tripName: destination, tripDates:dates),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
            // Trip details on the left
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Dates: $dates',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Duration: $duration',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              // Image for the destination
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageName,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wallet Page (for navigation)
class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
        backgroundColor: Colors.blue[900],
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
                color: Colors.blue[900],
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
                    icon: Icons.airplanemode_active,
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

// Wallet Card widget
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
            Icon(icon, size: 40, color: Colors.blue[900]),
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
