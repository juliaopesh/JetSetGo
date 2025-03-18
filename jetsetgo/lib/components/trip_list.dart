import 'package:flutter/material.dart';
import 'package:jetsetgo/components/trip_card.dart';

class TripList extends StatelessWidget {
  const TripList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        TripCard(
          destination: 'Barcelona, Spain',
          dates: 'Sept 20 - 27, 2025',
          duration: '7 days',
          imageName: 'assets/images/trip_card/barcelona_widget.jpg',
        ),
        TripCard(
          destination: 'Tokyo, Japan',
          dates: 'Oct 5 - 15, 2025',
          duration: '10 days',
          imageName: 'assets/images/trip_card/tokyo_widget.jpeg',
        ),
        TripCard(
          destination: 'Paris, France',
          dates: 'Nov 1 - 7, 2025',
          duration: '6 days',
          imageName: 'assets/images/trip_card/paris_widget.jpg',
        ),
      ],
    );
  }
}
