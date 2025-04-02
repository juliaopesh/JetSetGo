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
      width: 300, //fill parent container
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFD76C5B), // Warm terracotta default
          foregroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
