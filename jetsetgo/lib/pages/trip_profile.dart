import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TripScreen extends StatefulWidget {
  final String tripName;
  final String tripDates;
  final String tripLocation;

  const TripScreen({super.key, required this.tripName, required this.tripDates, required this.tripLocation});

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  // Weather data variables
  late String weatherDescription;
  late String temperature;
  late String humidity;
  bool isWeatherLoading = true;

  // Fetch weather data
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
        title: Text(
          widget.tripName,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 119, 165, 205),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "My trip to...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.tripName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Dates: ${widget.tripDates}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Wallet and Weather Section with dynamic sizing
              IntrinsicHeight(
                child: Row(
                  children: [
                    // Wallet Section
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to WalletPage when clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WalletPage()),
                          );
                        },
                        child: _buildFeatureBox(
                          Icons.account_balance_wallet,
                          "Wallet",
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Weather Section
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to WeatherPage or leave it as is
                        },
                        child: _buildWeatherBox(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Itinerary Section
              Text(
                "Itinerary",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...["Day 1", "Day 2", "Day 3"].map((day) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: _buildDayCard(day),
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Packing List Section
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Packing List",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the PackingListScreen when clicked
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text("Expand List"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.pink, thickness: 2),
                    Column(
                      children: [
                        _buildPackingItem("Item 1"),
                        _buildPackingItem("Item 2"),
                        _buildPackingItem("Item 3"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // space at bottom to avoid cutting content
            ],
          ),
        ),
      ),
    );
  }

  // Feature Box (Wallet)
  Widget _buildFeatureBox(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Icon(icon, size: 60),
        ],
      ),
    );
  }

  // Weather Box (Unified Widget for Weather)
  Widget _buildWeatherBox() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Weather",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Icon(Icons.wb_sunny, size: 60),
          SizedBox(height: 10),
          isWeatherLoading
              ? CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weather in ${widget.tripLocation}",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Description: $weatherDescription",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Temperature: $temperature°C",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Humidity: $humidity%",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // Itinerary Day Card
  Widget _buildDayCard(String day) {
    return Container(
      padding: EdgeInsets.all(15),
      width: 120, // Wider day card
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          SizedBox(height: 5),
          Text("• Activity 1\n• Activity 2", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Packing List Item
  Widget _buildPackingItem(String item) {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Text(item, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

// Dummy WalletPage class for navigation
class WalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wallet Page')),
      body: Center(child: Text('This is the Wallet Page')),
    );
  }
}
