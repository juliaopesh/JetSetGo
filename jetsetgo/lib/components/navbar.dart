import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/home_page.dart'; // Import your HomePage here

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
        } else {
          // Call the passed function for other items like Calendar
          onItemTapped(index);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
      ],
    );
  }
}
