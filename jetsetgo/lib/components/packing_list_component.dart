import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/packing_list.dart';

class PackingListSection extends StatefulWidget {
  final String tripTitle;

  const PackingListSection({super.key, required this.tripTitle});

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
    return Card(
      elevation: 5, // Matches TripCard elevation
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Matches TripCard border radius
      ),
      color: const Color.fromARGB(255, 241, 127, 168),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Packing List Header with Expand Button
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Packing List', // Trip title
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 253, 246, 248), // Matches TripCard text color
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PackingListScreen(
                          tripTitle: widget.tripTitle,
                        ),
                      ),
                    );
                  },
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
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 250, 236, 241),
                        ),
                        filled: true, //background colour enabled 
                        fillColor: Colors.transparent, //keep brackground same as parent
                         
                         border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12), 
                          borderSide: const BorderSide(
                            color: Colors.white, 
                            width: 1,
                          ),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white, 
                            width: 1,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white, 
                            width: 1,
                          ),
                        ),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.add, color: Color.fromARGB(255, 250, 239, 243)),
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Packing List Items
            if (_packingItems.isEmpty)
              const Center(
                child: Text(
                  "No items added yet.",
                  style: TextStyle(color: Color.fromARGB(255, 250, 239, 243)),
                ),
              )
            else
              Column(
                children: _packingItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  PackingItem item = entry.value;
                  return _buildPackingItem(item, index);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  // Packing Item Widget (Checkbox + Text + Delete)
  Widget _buildPackingItem(PackingItem item, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Checkbox(
          value: item.isChecked,
          onChanged: (value) => _toggleChecked(index),
          activeColor: const Color.fromARGB(255, 250, 239, 243),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
            decoration: item.isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => _deleteItem(index),
        ),
      ),
    );
  }
}

// Packing Item Model
class PackingItem {
  final String name;
  bool isChecked;

  PackingItem({required this.name, this.isChecked = false});
}
