import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetsetgo/utils/ai_packing_suggestions.dart';

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
    if (_controller.text.isNotEmpty) {
      await _packingListRef.add({
        'item': _controller.text.trim(),
        'checked': false,
      });
    }
  }

  Future<void> _toggleCheckbox(String id, bool checked) async {
    await _packingListRef.doc(id).update({'checked': checked ? 1 : 0});
  }

  Future<void> _deleteItem(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFA6BDA3), // Sage
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete this item?',
          style: TextStyle(color: Color(0xFF1F1F1F)),
        ),
        content: const Text(
          'Are you sure you want to remove this from your packing list?',
          style: TextStyle(color: Color(0xFF1F1F1F)),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF1F1F1F))),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Color(0xFFD76C5B))),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _packingListRef.doc(id).delete();
    }
  }

  void _showAddItemDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFA6BDA3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Add Item",
            style: TextStyle(color: Color(0xFF1F1F1F)),
          ),
          content: TextField(
            controller: _controller,
            style: const TextStyle(color: Color(0xFF1F1F1F)), // Charcoal text
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xFFC9D6C9), // Lighter sage
              hintText: "Enter item name",
              hintStyle: TextStyle(color: Color(0xFF888888)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Color(0xFF1F1F1F))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD76C5B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                _addItem(_controller.text);
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFA6BDA3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("AI Suggestions", style: TextStyle(color: Color(0xFF1F1F1F))),
        content: const Text(
          "This feature provides AI-generated packing recommendations based on your trip.",
          style: TextStyle(color: Color.fromARGB(255, 120, 117, 117)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it!", style: TextStyle(color: Color(0xFFD76C5B))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6BDA3), // Darker sage
      appBar: AppBar(
        title: Text("Packing List for ${widget.tripTitle}"),
        backgroundColor: const Color(0xFF2C2C2E),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFD76C5B)),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _packingListRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No items yet. Tap + to add.",
                style: TextStyle(
                  color: Color(0xFF1F1F1F),
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final item = data['item'] ?? '';
              final checked = data['checked'] == 1;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFC9D6C9), // Lighter sage
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: checked,
                      activeColor: const Color(0xFFD76C5B),
                      onChanged: (value) => _toggleCheckbox(doc.id, value!),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF1F1F1F),
                          decoration: checked ? TextDecoration.lineThrough : null,
                          decorationColor: const Color(0xFF1F1F1F), // visible line
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFD76C5B)),
                      onPressed: () => _deleteItem(doc.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _showInfoDialog,
              child: ClipOval(
                child: Container(
                  width: 30,
                  height: 30,
                  color: const Color(0xFFD76C5B),
                  alignment: Alignment.center,
                  child: const Icon(Icons.info, color: Colors.white, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final user = FirebaseAuth.instance.currentUser!;
                final tripDocRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('trip')
                    .doc(widget.tripId);

                try {
                  final tripIdSnapshot = await tripDocRef.collection('tripID').get();
                  final tripData = tripIdSnapshot.docs.isNotEmpty ? tripIdSnapshot.docs.first.data() : null;

                  if (tripData == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Trip details not found.")));
                    return;
                  }

                  final destination = "${tripData['City']}, ${tripData['Country']}";
                  final startDate = tripData['DateLeaving'].toString();
                  final endDate = tripData['DateReturning'].toString();

                  final packingSnapshot = await tripDocRef.collection('PackingList').get();
                  final items = packingSnapshot.docs.map((doc) {
                    final data = doc.data();
                    return data['item']?.toString() ?? '';
                  }).where((item) => item.isNotEmpty).toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackingAISuggestionsScreen(
                        tripId: widget.tripId,
                        destination: destination,
                        startDate: startDate,
                        endDate: endDate,
                        existingItems: items,
                      ),
                    ),
                  );
                } catch (e) {
                  print("Error fetching trip info or packing list: $e");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to fetch data.")));
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  color: const Color(0xFFD76C5B),
                  child: const Text(
                    "Get AI Suggestions",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
