import 'package:flutter/material.dart';
import 'package:jetsetgo/components/itinerary_daycard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    TextEditingController dayController = TextEditingController(
      text: isEditing ? itineraryDays[editIndex]["day"] : "",
    );

    List<TextEditingController> timeControllers = [];
    List<TextEditingController> activityControllers = [];
    List<String> amPmOptions = ["AM", "PM"];
    List<String> selectedAmPm = [];

    // **Pre-fill data if editing**
    if (isEditing) {
      List<String> existingActivities = itineraryDays[editIndex]["activities"];
      for (var activity in existingActivities) {
        var parts = activity.split(" - ");
        var timeParts = parts[0].split(" ");
        timeControllers.add(TextEditingController(text: timeParts[0])); // HH:MM
        selectedAmPm.add(timeParts[1]); // AM/PM
        activityControllers.add(TextEditingController(text: parts[1])); // Activity text
      }
    } else {
      // **Ensure at least one activity field when adding a new itinerary**
      timeControllers.add(TextEditingController());
      activityControllers.add(TextEditingController());
      selectedAmPm.add("AM");
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Itinerary Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              controller: dayController,
                              decoration: const InputDecoration(labelText: "Day Number (e.g., Day 3)"),
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(timeControllers.length, (index) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      controller: timeControllers[index],
                                      decoration: const InputDecoration(labelText: "HH:MM"),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  DropdownButton<String>(
                                    value: selectedAmPm[index],
                                    items: amPmOptions.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setDialogState(() {
                                        selectedAmPm[index] = newValue!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: activityControllers[index],
                                      decoration: const InputDecoration(labelText: "Activity"),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setDialogState(() {
                                        timeControllers.removeAt(index);
                                        activityControllers.removeAt(index);
                                        selectedAmPm.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                            TextButton(
                              onPressed: () {
                                setDialogState(() {
                                  timeControllers.add(TextEditingController());
                                  activityControllers.add(TextEditingController());
                                  selectedAmPm.add("AM");
                                });
                              },
                              child: const Text("+ Add Another Activity"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (dayController.text.isNotEmpty) {
                              List<String> activities = [];
                              for (int i = 0; i < timeControllers.length; i++) {
                                if (timeControllers[i].text.isNotEmpty && activityControllers[i].text.isNotEmpty) {
                                  activities.add("${timeControllers[i].text} ${selectedAmPm[i]} - ${activityControllers[i].text}");
                                }
                              }
                              if (activities.isNotEmpty) {
                                setState(() {
                                  if (isEditing) {
                                    _editItineraryDay(editIndex, dayController.text, activities);
                                  } else {
                                    _addNewItineraryDay(dayController.text, activities);
                                  }
                                });
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: Text(isEditing ? "Update" : "Add"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...itineraryDays.asMap().entries.map((entry) {
                int index = entry.key;
                var day = entry.value;
                return ItineraryDayCard(
                  day: day["day"]!,
                  activities: day["activities"]!,
                  onDelete: () => _deleteItineraryDay(index),
                  onEdit: () => _showItineraryDialog(context, editIndex: index),
                );
              }),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 40),
                onPressed: () => _showItineraryDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}