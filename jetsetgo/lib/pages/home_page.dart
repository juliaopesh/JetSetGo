import 'package:flutter/material.dart';
import 'wallet.dart'; // Import the new WalletPage file
import 'trip_profile.dart'; // Import the TripScreen file

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JetSetGo'),
        backgroundColor: const Color.fromARGB(255, 119, 165, 205),
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
                color: const Color.fromARGB(255, 119, 165, 205),
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
                    imageName: 'assets/images/widgets/barcelona_widget.jpg', 
                  ),
                  TripCard(
                    destination: 'Tokyo, Japan',
                    dates: 'Oct 5 - 15, 2025',
                    duration: '10 days',
                    imageName: 'assets/images/widgets/tokyo_widget.jpeg', 
                  ),
                  TripCard(
                    destination: 'Paris, France',
                    dates: 'Nov 1 - 7, 2025',
                    duration: '6 days',
                    imageName: 'assets/images/widgets/paris_widget.jpg', // Name of the image in your assets
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
                    MaterialPageRoute(builder: (context) => WalletPage()), // Navigate to the WalletPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 119, 165, 205), 
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
                        color: const Color.fromARGB(255, 119, 165, 205),
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
