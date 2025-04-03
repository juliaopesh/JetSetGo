import 'package:flutter/material.dart';

class WeatherSection extends StatelessWidget {
  final bool isWeatherLoading;
  final String? weatherDescription; // Nullable
  final String? temperature;        // Nullable
  final String? humidity;           // Nullable
  final String location;

  const WeatherSection({
    super.key,
    required this.isWeatherLoading,
    this.weatherDescription, // Nullable
    this.temperature,        // Nullable
    this.humidity,           // Nullable
    required this.location,
  });

  IconData _getWeatherIcon(String? description) {
    if (description == null) return Icons.help_outline;

    final lower = description.toLowerCase();

    if (lower.contains('sun') || lower.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lower.contains('cloud')) {
      return Icons.cloud;
    } else if (lower.contains('rain') || lower.contains('drizzle')) {
      return Icons.grain;
    } else if (lower.contains('storm')) {
      return Icons.flash_on;
    } else if (lower.contains('snow')) {
      return Icons.ac_unit;
    }

    return Icons.wb_cloudy;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Match the elevation of TripCard
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Match the border radius
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E2E), // Slightly lighter than charcoal
          borderRadius: BorderRadius.circular(12), // Match the border radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Weather",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFBE8D2), //peach! 
              ),
            ),
            const SizedBox(height: 16),
            
            // Optional soft background circle
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0x44FBE8D2), // Transparent coral
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    _getWeatherIcon(weatherDescription),
                    key: ValueKey(weatherDescription),
                    size: 80,
                    color: const Color(0xFFE38A71), // Coral icon
                  ),
                ),
              ),
            ),
            
            
            const SizedBox(height: 12),
            isWeatherLoading
                ? const CircularProgressIndicator(color: Color(0xFFFBE8D2)) // Loading state
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //const SizedBox(height: 10),
                      Text(
                        "Description: ${weatherDescription ?? 'Loading...'}", // Safely handle null
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD7DAD1), // Sage text
                        ),
                      ),
                      Text(
                        "Temperature: ${temperature ?? 'Loading...'}°C", // Safely handle null
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD7DAD1),
                        ),
                      ),
                      Text(
                        "Humidity: ${humidity ?? 'Loading...'}%", // Safely handle null
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD7DAD1),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
