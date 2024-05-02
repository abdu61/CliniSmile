import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String userId;
  final DateTime date;
  final TimeOfDay time;
  final String status;
  final String paymentMethod; // New field

  Appointment({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.date,
    required this.time,
    required this.status,
    required this.paymentMethod, // New field
  });
}
