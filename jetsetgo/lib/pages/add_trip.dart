import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetsetgo/components/add_button.dart'; // Import AddButton component
import 'trip_suggestions.dart';
class AddTrip extends StatefulWidget {
  const AddTrip({super.key});

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _dateLeavingController = TextEditingController();
  final _dateReturningController = TextEditingController();
  final _durationController = TextEditingController();
  final _monthController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    _dateLeavingController.dispose();
    _dateReturningController.dispose();
    _durationController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  Future<void> _addTrip() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser!;
      final tripData = {
        'City': _cityController.text,
        'Country': _countryController.text,
        'DateLeaving': int.parse(_dateLeavingController.text),
        'DateReturning': int.parse(_dateReturningController.text),
        'Duration': int.parse(_durationController.text),
        'Month': _monthController.text,
      };

      try {
        // Generate a unique ID for the trip document
        final tripDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('trip')
            .doc();

        // Create the trip document with the trip data
        await tripDocRef.set(tripData);

        // Reference to the Itinerary subcollection
        final itineraryDocRef = tripDocRef.collection('Itinerary').doc("Day 1 - Arrival");

        // Create the Title document (e.g., "Day 1 - Arrival")
        await itineraryDocRef.set({}); // Empty document, just to hold the subcollection

        // Create a Details document
        final detailsDocRef = itineraryDocRef.collection('Details').doc();

        await detailsDocRef.set({}); // Empty document to hold the subcollection

        // Add schedule under the Details document
        await detailsDocRef.collection('Schedule').add({
          'Time': '10:00',
          'AMorPM': 0, // 0 for AM, 1 for PM
          'Activity': 'Check into hotel',
        });

        await detailsDocRef.collection('Schedule').add({
          'Time': '02:00',
          'AMorPM': 1, // 1 for PM
          'Activity': 'Explore the city',
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip added successfully!')),
        );

        // Navigate back to the home page
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add trip: $e')),
        );
      }
    }
  }




  // Helper function to validate numeric fields
  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value for $fieldName';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match HomePage background
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Add a New Trip',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 244, 246), // Match HomePage app bar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripSuggestions()),
              );
            },
            child: const Text(
              'Suggest new trips for me',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_cityController, 'City'),
              const SizedBox(height: 15),
              _buildTextField(_countryController, 'Country'),
              const SizedBox(height: 15),
              _buildTextField(_dateLeavingController, 'Date Leaving', isNumber: true),
              const SizedBox(height: 15),
              _buildTextField(_dateReturningController, 'Date Returning', isNumber: true),
              const SizedBox(height: 15),
              _buildTextField(_durationController, 'Duration (days)', isNumber: true),
              const SizedBox(height: 15),
              _buildTextField(_monthController, 'Month'),
            ],
          ),
        ),
      ),
      floatingActionButton: AddButton(
        label: 'Add Trip',
        onPressed: _addTrip,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Centered FAB like HomePage
    );
  }

  // Helper function to create text fields
  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero, // Sharp edges
        ),
        filled: true,
        fillColor: Color.fromARGB(255, 252, 252, 252), // Match trip card color
      ),
      validator: isNumber ? (value) => _validateNumber(value, label) : (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
