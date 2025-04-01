import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchTripSuggestions({
  required String idealWeather,
  required String idealSetting,
  required String favoriteActivity,
  required String otherFavorites,
  required String startDate,
  required String endDate,
}) async {
  final String apiKey = const String.fromEnvironment('GEMINI_API_KEY');
  final String endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

  final prompt = '''
Suggest four travel destinations based on the following preferences:
- Ideal Weather: $idealWeather
- Ideal Setting: $idealSetting
- Favorite Activity: $favoriteActivity
- Other Preferences: $otherFavorites
- Trip Dates: $startDate to $endDate

Return only four city-country destinations in this format:
City, Country
City, Country
City, Country
City, Country
''';

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final text = data['candidates']?[0]['content']?['parts']?[0]['text'] ?? '';

    return LineSplitter.split(text)
        .map((line) => line.trim())
        .where((line) => line.contains(','))
        .toList();
  } else {
    throw Exception("Failed to fetch trip suggestions: ${response.statusCode}");
  }
}
