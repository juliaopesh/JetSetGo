import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;


  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), //vertical spacing
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white), // Typing color
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFA1A1A3)),
          filled: true,
          fillColor: const Color(0xFF2C2C2E), // Input bg
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color:Color(0xFF3A3A3C)),
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD76C5B), width: 2),
          ),
        ),
      )
    );
  }
}