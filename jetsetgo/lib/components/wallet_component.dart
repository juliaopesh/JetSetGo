import 'package:flutter/material.dart';

class WalletSection extends StatelessWidget {
  final VoidCallback onTap;

  const WalletSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5, // Match the elevation of TripCard
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Match the border radius
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.orange[100], // Light orange background
            borderRadius: BorderRadius.circular(12), // Match the border radius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Wallet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 48, 33, 6),
                ),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.wallet,
                size: 120,
                color: Color.fromARGB(255, 48, 33, 6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}