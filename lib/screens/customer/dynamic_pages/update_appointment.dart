import 'package:dental_clinic/models/appointment.dart';
import 'package:flutter/material.dart';

class UpdateAppointmentPage extends StatefulWidget {
  final Appointment appointment;

  UpdateAppointmentPage({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<UpdateAppointmentPage> createState() => _UpdateAppointmentPageState();
}

class _UpdateAppointmentPageState extends State<UpdateAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Update Appointment'),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        elevation: 0.0,
      ),
      body: Text('Update Appointment'),
    );
  }
}
