import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Appointment'),
        ),
        backgroundColor: Color(0xFF254EDB),
        elevation: 0.0,
      ),
      body: const Center(
        child: Text('Appointment'),
      ),
    );
  }
}
