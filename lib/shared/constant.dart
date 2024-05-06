import 'package:flutter/material.dart';

// Search bar decoration
const textInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(15.0),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF254EDB), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

final buttonAuthenticateStyle = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), // Rounded corners
  ),
  backgroundColor: const Color(0xFF254EDB),
  minimumSize: const Size(double.infinity, 50),
);
