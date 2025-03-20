import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItineraryService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a new itinerary
  Future<void> addItinerary(String tripId, String activity1, String activity2) async {
    final user = _auth.currentUser!;

    // Add a new document to the tripItinerary collection
    final itineraryRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(tripId)
        .collection('tripItinerary')
        .doc(); // Auto-generate a new document ID

    // Add a new document to the day1 subcollection
    await itineraryRef.collection('day1').doc().set({
      'Activity1': activity1,
      'Activity2': activity2,
    });
  }
}