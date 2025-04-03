import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:jetsetgo/utils/ai_trip_suggestions.dart';
import 'package:jetsetgo/pages/home_page.dart';
import 'package:jetsetgo/components/my_textfield.dart';
import 'package:jetsetgo/components/my_button.dart';

class TripSuggestions extends StatefulWidget {
  const TripSuggestions({super.key});

  @override
  _TripSuggestionsState createState() => _TripSuggestionsState();
}

class _TripSuggestionsState extends State<TripSuggestions> {
  String idealWeather = 'No Preference';
  String idealSetting = 'No Preference';
  String favoriteActivity = 'No Preference';
  final TextEditingController otherFavoritesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

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

  void _showTripOptions() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trip date range.')),
      );
      return;
    }

    try {
      final suggestions = await fetchTripSuggestions(
        idealWeather: idealWeather,
        idealSetting: idealSetting,
        favoriteActivity: favoriteActivity,
        otherFavorites: otherFavoritesController.text,
        startDate: _startDate.toString(),
        endDate: _endDate.toString(),
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2C2C2E),
            title: const Text('Suggested Trips', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: suggestions.map((destination) => _buildTripOption(destination)).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Color(0xFFD76C5B))),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch suggestions: $e')),
      );
    }
  }

  Future<void> _addTripProfile(String destination) async {
    if (_startDate == null || _endDate == null) return;

    final user = FirebaseAuth.instance.currentUser!;
    final duration = _endDate!.difference(_startDate!).inDays;
    final month = DateFormat.MMMM().format(_startDate!);

    final tripData = {
      'City': destination.split(', ')[0],
      'Country': destination.split(', ')[1],
      'DateLeaving': _startDate!.day,
      'DateReturning': _endDate!.day,
      'Duration': duration,
      'Month': month,
      'IdealWeather': idealWeather,
      'IdealSetting': idealSetting,
      'FavoriteActivity': favoriteActivity,
      'OtherFavorites': otherFavoritesController.text,
    };

    try {
      final tripDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('trip')
          .doc();

      await tripDocRef.set({});
      await tripDocRef.collection('tripID').doc().set(tripData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip added successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add trip: $e')),
      );
    }
  }

  Widget _buildTripOption(String destination) {
    return ListTile(
      title: Text(destination, style: const TextStyle(color: Colors.white)),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: Color(0xFFD76C5B)),
        onPressed: () => _addTripProfile(destination),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateSummary = (_startDate != null && _endDate != null)
        ? "${DateFormat.MMMd().format(_startDate!)} - ${DateFormat.MMMd().format(_endDate!)} (${_endDate!.difference(_startDate!).inDays} days)"
        : "Select Trip Dates";

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Trip Suggestions',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown('Ideal Weather', [
                'Warm', 'Cold', 'Hot', 'No Preference'
              ], (value) => setState(() => idealWeather = value)),
              _buildDropdown('Ideal Setting', [
                'Cities', 'Towns', 'Villages', 'Nature', 'Remote', 'Islands', 'Cabins', 'Camping', 'No Preference'
              ], (value) => setState(() => idealSetting = value)),
              _buildDropdown('Favorite Activity', [
                'Sightseeing', 'Hiking', 'Swimming', 'No Preference'
              ], (value) => setState(() => favoriteActivity = value)),
              const SizedBox(height: 16),
              MyTextField(
                controller: otherFavoritesController,
                hintText: 'Other Favorites',
                obscureText: false,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF2C2C2E),
                  ),
                  child: Text(
                    dateSummary,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              MyButton(
                color: Color.fromARGB(255, 140, 160, 225),
                text: 'Generate Options',
                onTap: _showTripOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        dropdownColor: const Color(0xFF2C2C2E),
        value: options.last,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color(0xFF2C2C2E),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD76C5B)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white70,
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) => onChanged(value!),
      ),
    );
  }
}
