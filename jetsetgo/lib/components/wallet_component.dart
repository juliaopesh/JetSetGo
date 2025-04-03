import 'package:flutter/material.dart';

class WalletSection extends StatelessWidget {
  final VoidCallback onTap;

  const WalletSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E), 
            borderRadius: BorderRadius.circular(12),
          ),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Wallet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Clean, readable
                ),
              ),
              SizedBox(height: 10),
              Icon(
                Icons.wallet,
                size: 120,
                color: Colors.white70, // Soft white, not too harsh
              ),
            ],
          ),
        ),
      ),
    );
  }
}
