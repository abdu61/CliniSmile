import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/shared/widgets/cards/doctor_card.dart';
import 'package:flutter/material.dart';

class BookAppointmentPage extends StatelessWidget {
  final Doctor? doctor;

  BookAppointmentPage({this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Details',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DoctorCard(
              doctor: doctor!,
              showAbout: false,
              showMoreInformation: false,
            ),
            // Date picker
            ElevatedButton(
              onPressed: () {
                // Handle date selection
              },
              child: Text('Select Date'),
            ),
            // Time picker
            ElevatedButton(
              onPressed: () {
                // Handle time selection
              },
              child: Text('Select Time'),
            ),
            // Consultation type toggle
            ToggleButtons(
              children: [
                Icon(Icons.videocam),
                Icon(Icons.store),
              ],
              onPressed: (int index) {
                // Handle consultation type selection
              },
              isSelected: [true, false],
            ),
            // Submit button
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 220, 227, 255),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Book Appointment',
              style: textTheme.labelLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
