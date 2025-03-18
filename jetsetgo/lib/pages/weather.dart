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
  late String weatherDescription;
  late String temperature;
  late String humidity;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final String apiKey = '<My API Key>';  // Replace with your actual API key
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
      appBar: AppBar(title: Text('Weather for ${widget.tripLocation}')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Weather: $weatherDescription', style: TextStyle(fontSize: 22)),
                  Text('Temperature: $temperature°C', style: TextStyle(fontSize: 20)),
                  Text('Humidity: $humidity%', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
    );
  }
}
