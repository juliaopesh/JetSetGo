import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PackingListSection extends StatefulWidget {
  final String tripTitle;
  final String tripId;

  const PackingListSection({super.key, required this.tripTitle, required this.tripId});

  @override
  _PackingListSectionState createState() => _PackingListSectionState();
}

class _PackingListSectionState extends State<PackingListSection> {
  final TextEditingController _controller = TextEditingController();
  late CollectionReference _packingListRef;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!;
    _packingListRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Replace with actual user ID
        .collection('trip')
        .doc(widget.tripId)
        .collection('PackingList');
  }

  // Add item to Firestore
  Future<void> _addItem() async {
    if (_controller.text.isNotEmpty) {
      await _packingListRef.add({
        'item': _controller.text,
        'checked': false, // Ensure it's a boolean
      });
      _controller.clear();
    }
  }

  // Delete item from Firestore
  Future<void> _deleteItem(String itemId) async {
    await _packingListRef.doc(itemId).delete();
  }

  // Toggle checked status in Firestore
  Future<void> _toggleChecked(String itemId, bool isChecked) async {
    await _packingListRef.doc(itemId).update({'checked': isChecked ? 1 : 0});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color.fromARGB(255, 241, 127, 168),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Packing List Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Packing List',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 253, 246, 248),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Color.fromARGB(255, 245, 184, 207)),

            // Add Item Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Add item',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Packing List Items from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: _packingListRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data!.docs;

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "No items added yet.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return Column(
                  children: items.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    bool isChecked = (data['checked'] == 1); 

                    return _buildPackingItem(doc.id, data['item'], isChecked);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Packing Item Widget
  Widget _buildPackingItem(String itemId, String name, bool isChecked) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Checkbox(
          value: isChecked,
          onChanged: (value) => _toggleChecked(itemId, value!),
          activeColor: const Color.fromARGB(255, 250, 239, 243),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            decoration: isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteItem(itemId),
        ),
      ),
    );
  }
}
