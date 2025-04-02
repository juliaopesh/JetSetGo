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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete this item?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to remove this from your packing list?',
          style: TextStyle(color: Color(0xFFA1A1A3)),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _packingListRef.doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item deleted"),
          backgroundColor: Color(0xFF2C2C2E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("AI Suggestions"),
          content: Text(
              "This feature provides AI-generated packing recommendations based on your trip."),
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
                          decoration:
                              checked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteItem(doc.id),
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
            // Info button
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
            const SizedBox(width: 10),
            // Get AI Suggestions button
            GestureDetector(
              onTap: () async {
              final user = FirebaseAuth.instance.currentUser!;
              final tripDocRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('trip')
                  .doc(widget.tripId);

              try {
                // 1. Get trip details (from tripID subcollection)
                final tripIdSnapshot = await tripDocRef.collection('tripID').get();
                final tripData = tripIdSnapshot.docs.isNotEmpty ? tripIdSnapshot.docs.first.data() : null;

                if (tripData == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Trip details not found.")));
                  return;
                }

                final destination = "${tripData['City']}, ${tripData['Country']}";
                final startDate = tripData['DateLeaving'].toString(); // Format if needed
                final endDate = tripData['DateReturning'].toString();

                // 2. Get packing list items
                final packingSnapshot = await tripDocRef.collection('PackingList').get();
                final items = packingSnapshot.docs.map((doc) {
                  final data = doc.data();
                  return data['item']?.toString() ?? '';
                }).where((item) => item.isNotEmpty).toList();

                // Navigate to AI Suggestions Screen
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  color: const Color.fromARGB(255, 233, 40, 123),
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
