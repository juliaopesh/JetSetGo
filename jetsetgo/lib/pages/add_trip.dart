import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

        // Create the trip document
        await tripDocRef.set({}); // Initialize the trip document (can be empty)

        // Add trip details to the tripID subcollection
        await tripDocRef
            .collection('tripID')
            .doc() // Automatically generate a unique ID for the tripID document
            .set(tripData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip added successfully!')),
        );

        // Navigate back to the home page
        Navigator.pop(context);
      } catch (e) {
        // Show error message
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
      appBar: AppBar(
        title: const Text('Add Trip'),
        backgroundColor: const Color.fromARGB(255, 119, 165, 205),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a country';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateLeavingController,
                decoration: const InputDecoration(labelText: 'Date Leaving'),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Date Leaving'),
              ),
              TextFormField(
                controller: _dateReturningController,
                decoration: const InputDecoration(labelText: 'Date Returning'),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Date Returning'),
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (days)'),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Duration'),
              ),
              TextFormField(
                controller: _monthController,
                decoration: const InputDecoration(labelText: 'Month'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a month';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTrip,
                child: const Text('Add Trip'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}