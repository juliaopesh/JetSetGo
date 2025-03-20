import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/packing_list.dart';

class PackingListSection extends StatelessWidget {
  const PackingListSection({super.key});

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
              const Text(
                "Packing List",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 28, 1, 38),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the PackingListScreen when clicked
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
          Column(
            children: [
              _buildPackingItem("Item 1"),
              _buildPackingItem("Item 2"),
              _buildPackingItem("Item 3"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackingItem(String item) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
          activeColor: const Color.fromARGB(255, 212, 187, 230),
        ),
        Text(
          item,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}