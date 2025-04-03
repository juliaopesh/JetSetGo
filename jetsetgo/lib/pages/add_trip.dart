import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jetsetgo/components/my_textfield.dart';
import 'package:jetsetgo/components/my_button.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _addTrip() async {
    if (_formKey.currentState!.validate() && _startDate != null && _endDate != null) {
      final user = FirebaseAuth.instance.currentUser!;
      final duration = _endDate!.difference(_startDate!).inDays;
      final month = DateFormat.MMMM().format(_startDate!);

      final tripData = {
        'City': _cityController.text,
        'Country': _countryController.text,
        'DateLeaving': _startDate!.day,
        'DateReturning': _endDate!.day,
        'Duration': duration,
        'Month': month,
      };

      try {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final tripDocRef = await userDoc.collection('trip').add({});
        final tripIdDocRef = tripDocRef.collection('tripID').doc();
        await tripIdDocRef.set(tripData);

        final itineraryDocRef = tripDocRef.collection('Itinerary').doc("Day 1 - Arrival");
        await itineraryDocRef.set({});
        await itineraryDocRef.collection('Details').doc().set({});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add trip: $e')),
        );
      }
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD76C5B),
              surface: Color(0xFF1C1C1E),
            ),
            dialogBackgroundColor: const Color(0xFF2C2C2E),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateString = (_startDate != null && _endDate != null)
        ? "${DateFormat.MMMd().format(_startDate!)} - ${DateFormat.MMMd().format(_endDate!)}"
        : "Select Trip Dates";

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Add a New Trip',
          style: TextStyle(fontSize: 24, color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFD76C5B),
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10, left: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _addTrip,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'Add Trip',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              MyTextField(
                controller: _cityController,
                hintText: 'City',
                obscureText: false,
              ),
              const SizedBox(height: 16),
              MyTextField(
                controller: _countryController,
                hintText: 'Country',
                obscureText: false,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF2C2C2E),
                  ),
                  child: Text(
                    dateString,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_startDate != null && _endDate != null)
                Text(
                  'Duration: ${_endDate!.difference(_startDate!).inDays} days',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              const SizedBox(height: 30),
              Center(
                child: MyButton(
                  color: const Color.fromARGB(255, 140, 160, 225),
                  text: 'Suggest new trips for me',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TripSuggestions()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
