import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class TripSuggestions extends StatefulWidget {
  const TripSuggestions({super.key});

  @override
  _TripSuggestionsState createState() => _TripSuggestionsState();
}

class _TripSuggestionsState extends State<TripSuggestions> {
  String favoriteSeason = 'No Preference';
  String idealWeather = 'No Preference';
  String idealSetting = 'No Preference';
  String idealContinent = 'No Preference';
  String favoriteActivity = 'No Preference';
  final TextEditingController otherFavoritesController = TextEditingController();
  final TextEditingController dateLeavingController = TextEditingController();
  final TextEditingController dateReturningController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController monthController = TextEditingController();

  void _showTripOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Suggested Trips'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTripOption('Rome, Italy'),
              _buildTripOption('Syracuse, Italy'),
              _buildTripOption('Vienna, Austria'),
              _buildTripOption('Budapest, Hungary'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addTripProfile(String destination) async {
    final user = FirebaseAuth.instance.currentUser!;
    final tripData = {
      'City': destination.split(', ')[0],
      'Country': destination.split(', ')[1],
      'DateLeaving': dateLeavingController.text,
      'DateReturning': dateReturningController.text,
      'Duration': durationController.text,
      'Month': monthController.text,
      'FavoriteSeason': favoriteSeason,
      'IdealWeather': idealWeather,
      'IdealSetting': idealSetting,
      'IdealContinent': idealContinent,
      'FavoriteActivity': favoriteActivity,
      'OtherFavorites': otherFavoritesController.text,
    };

    try {
      final tripDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('trip')
          .doc();

      await tripDocRef.set({}); // Initialize trip document
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
      title: Text(destination),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.blue),
        onPressed: () => _addTripProfile(destination),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Trip Suggestions',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 244, 246),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown('Favorite Season', [
                'Summer', 'Fall', 'Winter', 'Spring', 'No Preference'
              ], (value) => setState(() => favoriteSeason = value)),
              _buildDropdown('Ideal Weather', [
                'Warm', 'Cold', 'Hot', 'No Preference'
              ], (value) => setState(() => idealWeather = value)),
              _buildDropdown('Ideal Setting', [
                'Cities', 'Towns', 'Villages', 'Nature', 'Remote', 'Islands', 'Cabins', 'Camping', 'No Preference'
              ], (value) => setState(() => idealSetting = value)),
              _buildDropdown('Ideal Continent', [
                'East Asia', 'West Asia', 'South Asia', 'North Asia', 'Europe', 'North America', 'Central America', 'South America', 'Australia', 'No Preference'
              ], (value) => setState(() => idealContinent = value)),
              _buildDropdown('Favorite Activity', [
                'Sightseeing', 'Hiking', 'Swimming', 'No Preference'
              ], (value) => setState(() => favoriteActivity = value)),
              _buildTextField('Other Favorites', otherFavoritesController),
              _buildTextField('Date Leaving', dateLeavingController),
              _buildTextField('Date Returning', dateReturningController),
              _buildTextField('Duration', durationController),
              _buildTextField('Month', monthController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showTripOptions,
                child: const Text('Generate Options'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: options.last,
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: (value) => onChanged(value as String),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
