import 'package:flutter/material.dart';

class StaffAppointment extends StatefulWidget {
  const StaffAppointment({super.key});

  @override
  State<StaffAppointment> createState() => _StaffAppointmentState();
}

class _StaffAppointmentState extends State<StaffAppointment> {
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
