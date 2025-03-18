import 'package:flutter/material.dart';
import 'package:jetsetgo/pages/wallet.dart';

class WalletButton extends StatelessWidget {
  const WalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalletPage()), // Navigate to WalletPage
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 119, 165, 205),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: const Text(
        'Go to Wallet',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
