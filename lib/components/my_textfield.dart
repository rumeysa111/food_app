import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obsureText;
  final TextEditingController controller;
  final String label;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obsureText,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,

          ),
          floatingLabelBehavior: FloatingLabelBehavior.always, // Etiket her zaman yukarıda kalacak
          enabledBorder: OutlineInputBorder(

            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.white70,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey
          ),
        ),
      ),
    );
  }
}
