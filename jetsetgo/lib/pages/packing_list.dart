import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PackingListScreen extends StatefulWidget {
  final String tripTitle;
  final String tripId;

  const PackingListScreen({
    super.key,
    required this.tripTitle,
    required this.tripId,
  });

  @override
  _PackingListScreenState createState() => _PackingListScreenState();
}

class _PackingListScreenState extends State<PackingListScreen> {
  late CollectionReference _packingListRef;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    _packingListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('trip')
        .doc(widget.tripId)
        .collection('PackingList');
  }

  Future<void> _addItem(String item) async {
    if (item.trim().isNotEmpty) {
      await _packingListRef.add({
        'item': item.trim(),
        'checked': false,
      });
    }
  }

  Future<void> _toggleCheckbox(String id, bool checked) async {
    await _packingListRef.doc(id).update({'checked': checked ? 1 : 0});
  }

  Future<void> _deleteItem(String id) async {
    await _packingListRef.doc(id).delete();
  }

  void _showAddItemDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Item"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Enter item name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _addItem(_controller.text);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getAISuggestions() async {
    final String geminiApiUrl = 'https://api.gemini.com/ai_suggestions'; // Placeholder

    try {
      final response = await http.post(
        Uri.parse(geminiApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'trip_title': widget.tripTitle}),
      );

      if (response.statusCode == 200) {
        // Handle suggestions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("AI suggestions fetched!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching AI suggestions")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error connecting to Gemini API")),
      );
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("AI Suggestions"),
          content: Text("This feature provides AI-generated packing recommendations based on your trip."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Got it!"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Packing List for ${widget.tripTitle}"),
        backgroundColor: const Color.fromARGB(255, 241, 127, 168),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _packingListRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return docs.isEmpty
              ? Center(child: Text("No items yet. Tap + to add."))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final item = data['item'] ?? '';
                    final checked = data['checked'] == 1;

                    return ListTile(
                      leading: Checkbox(
                        value: checked,
                        onChanged: (value) => _toggleCheckbox(doc.id, value!),
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: checked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(doc.id),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: _showInfoDialog,
            child: ClipOval(
              child: Container(
                width: 30,
                height: 30,
                color: const Color.fromARGB(255, 233, 40, 123),
                alignment: Alignment.center,
                child: Icon(Icons.info, color: Colors.white, size: 20),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: _getAISuggestions,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 60,
                color: const Color.fromARGB(255, 233, 40, 123),
                alignment: Alignment.center,
                child: Text(
                  "Get AI Suggestions",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
