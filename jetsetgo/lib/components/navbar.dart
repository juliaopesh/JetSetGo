import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/home_page.dart'; // Import your HomePage here
import 'package:jetsetgo/pages/profile_page.dart'; // Import ProfilePage here

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 0) {
          // Navigate to HomePage directly when Home icon is tapped
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Always go to HomePage
          );
        } else if (index == 1) {
          // Navigate to ProfilePage when Profile icon is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to ProfilePage
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person), // Profile icon instead of calendar
          label: 'Profile',
        ),
      ],
    );
  }
}
