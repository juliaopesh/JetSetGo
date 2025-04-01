import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  final String tripName;
  final String tripDates;
  final String tripLocation;

  const WeatherPage({
    super.key,
    required this.tripName,
    required this.tripDates,
    required this.tripLocation,
  });

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // Make the variables nullable instead of using `late`
  String? weatherDescription;
  String? temperature;
  String? humidity;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final String apiKey = const String.fromEnvironment('OPENWEATHER_API_KEY');  // Access Dart define
    if (apiKey.isEmpty) {
      // Handle the case if API key is missing
      setState(() {
        weatherDescription = 'API key is missing';
        temperature = '';
        humidity = '';
        isLoading = false;
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
        isLoading = false;
      });
    } else {
      setState(() {
        weatherDescription = 'Error fetching weather data';
        temperature = '';
        humidity = '';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Safely handle null values using null-aware operators
                  Text('Weather: ${weatherDescription ?? 'Loading...'}', style: TextStyle(fontSize: 22)),
                  Text('Temperature: ${temperature ?? 'Loading...'}°C', style: TextStyle(fontSize: 20)),
                  Text('Humidity: ${humidity ?? 'Loading...'}%', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
    );
  }
}
