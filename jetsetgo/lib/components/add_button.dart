import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AddButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, // Set the width of the button
      height: 80, // Set the height of the button
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: const Color(0xFFD76C5B),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 36, // Larger icon size
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12, // Smaller font size
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}