import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/packing_list.dart'; // Make sure this is the correct import

class PackingListSection extends StatefulWidget {
  final String tripTitle; // Add tripTitle as a parameter to the constructor

  const PackingListSection({super.key, required this.tripTitle}); // Constructor to receive tripTitle

  @override
  _PackingListSectionState createState() => _PackingListSectionState();
}

class _PackingListSectionState extends State<PackingListSection> {
  final TextEditingController _controller = TextEditingController();
  List<PackingItem> _packingItems = [];

  // Add item to the list
  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _packingItems.add(PackingItem(name: _controller.text));
        _controller.clear();
      });
    }
  }

  // Delete item from the list
  void _deleteItem(int index) {
    setState(() {
      _packingItems.removeAt(index);
    });
  }

  // Toggle the checkbox for an item
  void _toggleChecked(int index) {
    setState(() {
      _packingItems[index].isChecked = !_packingItems[index].isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 212, 187, 230),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.tripTitle, // Use the tripTitle passed from the parent widget
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 28, 1, 38),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to PackingListScreen when clicked
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PackingListScreen(
                      tripTitle: widget.tripTitle,
                      //tripId: tripId, // Pass the tripId to PackingListScreen
                    ),
                  ),
                );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PackingListScreen(
                        tripTitle: "My Trip", // Pass the trip title here
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Expand List"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 212, 187, 230),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Color.fromARGB(255, 212, 187, 230)),

          // Text field to add new item
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Add new item to the packing list',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addItem,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Packing List Items
          Column(
            children: _packingItems.map((item) {
              int index = _packingItems.indexOf(item);
              return _buildPackingItem(item, index);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPackingItem(PackingItem item, int index) {
    return Row(
      children: [
        Checkbox(
          value: item.isChecked,
          onChanged: (value) {
            _toggleChecked(index);
          },
          activeColor: const Color.fromARGB(255, 212, 187, 230),
        ),
        Text(
          item.name,
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteItem(index),
        ),
      ],
    );
  }
}

class PackingItem {
  final String name;
  bool isChecked;

  PackingItem({required this.name, this.isChecked = false});
}
