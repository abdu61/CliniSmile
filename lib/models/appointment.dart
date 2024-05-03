import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String userId;
  final DateTime date;
  final TimeOfDay time;
  final String status;
  final String paymentMethod;
  final DateTime bookingTime;
  final String billedAmount;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.userId,
    required this.date,
    required this.time,
    required this.status,
    required this.paymentMethod,
    required this.bookingTime,
    this.billedAmount = '0.0',
  });
}
