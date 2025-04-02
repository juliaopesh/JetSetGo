import 'package:flutter/material.dart';
import 'package:jetsetgo/components/itinerary_daycard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetsetgo/components/itinerary_popup.dart';

class ItinerarySection extends StatefulWidget {
  final String tripId;
  const ItinerarySection({super.key, required this.tripId});

  @override
  _ItinerarySectionState createState() => _ItinerarySectionState();
}

class _ItinerarySectionState extends State<ItinerarySection> {

    List<Map<String, dynamic>> itineraryDays = [];
    late String tripId = widget.tripId;

  @override
  void initState() {
    super.initState();
    _fetchItinerary();
  }

  Future<void> _fetchItinerary() async {
    final user = FirebaseAuth.instance.currentUser!;
    final itinerarySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(tripId)
        .collection('itinerary')
        .get();

    setState(() {
      itineraryDays = itinerarySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "day": doc["day"],
          "activities": List<String>.from(doc["activities"]),
        };
      }).toList();
    });
  }
  // **Function to Add New Itinerary Day**
  Future<void> _addNewItineraryDay(String day, List<String> activities) async {
    final user = FirebaseAuth.instance.currentUser!;
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(tripId)
        .collection('itinerary')
        .add({
      "day": day,
      "activities": activities,
    });

    setState(() {
      itineraryDays.add({"id": docRef.id, "day": day, "activities": activities});
    });
  }

  // **Function to Edit an Existing Itinerary Day**
  Future<void> _editItineraryDay(int index, String newDay, List<String> newActivities) async {
    final user = FirebaseAuth.instance.currentUser!;
    String docId = itineraryDays[index]["id"];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(tripId)
        .collection('itinerary')
        .doc(docId)
        .update({
      "day": newDay,
      "activities": newActivities,
    });

    setState(() {
      itineraryDays[index] = {"id": docId, "day": newDay, "activities": newActivities};
    });
  }

  // **Function to Remove an Itinerary Day**
  Future<void> _deleteItineraryDay(int index) async {
    final user = FirebaseAuth.instance.currentUser!;
    String docId = itineraryDays[index]["id"];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(tripId)
        .collection('itinerary')
        .doc(docId)
        .delete();

    setState(() {
      itineraryDays.removeAt(index);
    });
  }


  // **Show Dialog to Add or Edit an Itinerary**
  void _showItineraryDialog(BuildContext context, {int? editIndex}) {
  bool isEditing = editIndex != null;
  String? existingDay = isEditing ? itineraryDays[editIndex]["day"] : null;
  List<String>? existingActivities = isEditing ? itineraryDays[editIndex]["activities"] : null;

  showItineraryDialog(
    context: context,
    isEditing: isEditing,
    existingDay: existingDay,
    existingActivities: existingActivities,
    onSave: (day, activities) {
      setState(() {
        if (isEditing) {
          _editItineraryDay(editIndex!, day, activities);
        } else {
          _addNewItineraryDay(day, activities);
        }
      });
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Itinerary",
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(vertical:10),
          child: itineraryDays.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),  
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_today, color: Colors.white70, size: 40), 
                    SizedBox(height: 16),
                    Text(
                      "No itinerary days added yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Tap the + icon to start planning your trip :)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFFA1A1A3)),
                    ), 
                  ],
                )
              )
            : Wrap(
              spacing: 16, 
              runSpacing: 16, 
              children: [
                ...itineraryDays.asMap(). entries.map((entry){
                  int index = entry.key; 
                  var day = entry.value; 
                  return ItineraryDayCard(
                    day: day["day"]!,
                    activities: day["activities"]!, 
                    onDelete: () => _deleteItineraryDay(index), 
                    onEdit: () => _showItineraryDialog(context, editIndex: index), 
                  ); 
                }), 
              ], 
            ), 
      
        ),

        // add button always shown 
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.add_circle, size: 40, color: Colors.green),
            onPressed: () => _showItineraryDialog(context), 
          ),
        ), 
      ], 
    ); 
  }
}
  