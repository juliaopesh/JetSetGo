import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PackingAISuggestionsScreen extends StatefulWidget {
  final String destination;
  final String startDate;
  final String endDate;
  final List<String> existingItems;
  final String tripId;

  const PackingAISuggestionsScreen({
    super.key,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.existingItems,
    required this.tripId,
  });

  @override
  State<PackingAISuggestionsScreen> createState() =>
      _PackingAISuggestionsScreenState();
}

class _PackingAISuggestionsScreenState
    extends State<PackingAISuggestionsScreen> {
  bool isLoading = true;
  final String apiKey = const String.fromEnvironment('GEMINI_API_KEY');
  Map<String, List<String>> suggestionsByCategory = {};
  Set<String> selectedItems = {};

  @override
  void initState() {
    super.initState();
    _generatePackingList();
  }

  Future<void> _generatePackingList() async {
    final String endpoint =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

    final prompt = '''
Create a categorized packing list for a leisure trip to ${widget.destination}.
The trip lasts from ${widget.startDate} to ${widget.endDate}.
The user has already packed: ${widget.existingItems.isEmpty ? 'nothing yet' : widget.existingItems.join(', ')}.
Group items using this format:

*Category Name*
- item 1
- item 2

Return only the list. Do not include extra explanation.
''';

    try {
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
        final suggestionText = data['candidates']?[0]['content']?['parts']?[0]['text'] ??
            "No suggestion received.";
        _parseSuggestions(suggestionText);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _parseSuggestions(String text) {
    final lines = LineSplitter.split(text).toList();
    String currentCategory = '';
    Map<String, List<String>> parsed = {};

    for (var line in lines) {
      if (line.startsWith('*') && line.endsWith('*')) {
        currentCategory = line.replaceAll('*', '').trim();
        parsed[currentCategory] = [];
      } else if (line.startsWith('-')) {
        parsed[currentCategory]?.add(line.replaceFirst('-', '').trim());
      }
    }

    setState(() {
      suggestionsByCategory = parsed;
      isLoading = false;
    });
  }

  Future<void> _saveSelectedItemsToFirebase() async {
    final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(widget.tripId)
        .collection('PackingList');

    for (String item in selectedItems) {
      await ref.add({'item': item, 'checked': false});
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Selected items saved to packing list.")),
    );
  }

  Widget _buildCategorySection(String category, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Icons.label_important, color:  Color(0xFFA6BDA3)),
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(thickness: 1.5, color: Colors.grey),
        ...items.map((item) => CheckboxListTile(
              title: Text(
                item,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                ),
              ),
              value: selectedItems.contains(item),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: const Color(0xFFD76C5B),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(
           "AI Suggestions: ${widget.destination}",
           style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3, // wrap if needed
            textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFF1C1C1E),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : suggestionsByCategory.isEmpty
              ? const Center(child: Text("No suggestions found."))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: suggestionsByCategory.entries
                        .map((entry) =>
                            _buildCategorySection(entry.key, entry.value))
                        .toList(),
                  ),
                ),
    );
  }
}
