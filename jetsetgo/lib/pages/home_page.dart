import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jetsetgo/components/logout_button.dart';
import 'package:jetsetgo/components/trip_list.dart';
import 'package:jetsetgo/components/wallet_button.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.blue[900],
        actions: [LogoutButton()], // ✅ Uses the LogoutButton component
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Add "LOGGED IN AS:" Section Here
            Text(
              "LOGGED IN AS: ${user.email!}", // Correct way to concatenate
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 10), // Add spacing

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

            // List of trips
            Expanded(child: TripList()), // ✅ Uses TripList component

            SizedBox(height: 20),

            // Wallet Button
            Center(child: WalletButton()), // ✅ Uses WalletButton component
          ],
        ),
      ),
    );
  }
}
