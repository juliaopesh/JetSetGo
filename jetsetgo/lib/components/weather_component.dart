import 'package:flutter/material.dart';

class WeatherSection extends StatelessWidget {
  final bool isWeatherLoading;
  final String weatherDescription;
  final String temperature;
  final String humidity;
  final String location;

  const WeatherSection({
    super.key,
    required this.isWeatherLoading,
    required this.weatherDescription,
    required this.temperature,
    required this.humidity,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Match the elevation of TripCard
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Match the border radius
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.lightBlue[100], // Light blue background
          borderRadius: BorderRadius.circular(12), // Match the border radius
        ),
        child: Column(
          children: [
            const Text(
              "Weather",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Icon(
              Icons.wb_sunny,
              size: 80,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            isWeatherLoading
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Weather in $location",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Description: $weatherDescription",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Temperature: $temperature°C",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Humidity: $humidity%",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}