import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jetsetgo/components/itinerary_component.dart';
import 'package:jetsetgo/components/packing_list_component.dart';
import 'package:jetsetgo/components/wallet_component.dart';
import 'package:jetsetgo/components/weather_component.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:jetsetgo/pages/wallet.dart';

class TripScreen extends StatefulWidget {
  final String tripName;
  final String tripDates;
  final String tripLocation;
  final String tripId;
  const TripScreen({
    super.key,
    required this.tripName,
    required this.tripDates,
    required this.tripLocation,
    required this.tripId,
  });

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  late String weatherDescription = 'Loading...';
  late String temperature = '0';
  late String humidity = '0';
  bool isWeatherLoading = true;

  Future<void> _fetchWeatherData() async {
    final String apiKey = const String.fromEnvironment('OPENWEATHER_API_KEY');
    if (apiKey.isEmpty) {
      setState(() {
        weatherDescription = 'API key is missing';
        temperature = '';
        humidity = '';
        isWeatherLoading = false;
      });
      return;
    }

    final String location = widget.tripLocation;

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        weatherDescription = data['weather'][0]['description'];
        temperature = data['main']['temp'].toString();
        humidity = data['main']['humidity'].toString();
        isWeatherLoading = false;
      });
    } else {
      setState(() {
        weatherDescription = 'Error fetching weather data';
        temperature = '';
        humidity = '';
        isWeatherLoading = false;
      });
    }
  }

  Future<void> deleteTrip() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('trip')
          .doc(widget.tripId)
          .delete();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip deleted successfully.')),
        );
      }
    } catch (e) {
      print('Error deleting trip: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trip: $e')),
      );
    }
  }

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Trip'),
          content: const Text('Are you sure you want to delete this trip? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteTrip();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          'Trip Details',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 245, 244, 246),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            iconSize: 30, // Increased icon size
            onPressed: showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Box
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "My trip to...",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.tripName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Dates: ${widget.tripDates}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Wallet and Weather Section
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: WalletSection(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WalletPage(tripName: widget.tripName),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: WeatherSection(
                        isWeatherLoading: isWeatherLoading,
                        weatherDescription: weatherDescription,
                        temperature: temperature,
                        humidity: humidity,
                        location: widget.tripLocation,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Itinerary Section
              ItinerarySection(tripId: widget.tripId),
              const SizedBox(height: 20),

              // Packing List Section
              PackingListSection(
                  tripTitle: widget.tripName, tripId: widget.tripId),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
