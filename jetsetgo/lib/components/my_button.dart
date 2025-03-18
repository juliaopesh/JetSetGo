import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color; // Optional custom color

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color, // Allows color customization
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Adjust width as needed
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color.fromARGB(255, 212, 187, 230), // Default: Blue
          foregroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
