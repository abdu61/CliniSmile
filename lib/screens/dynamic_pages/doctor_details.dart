import 'package:dental_clinic/shared/widgets/cards/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/models/doctor.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor? doctor;

  DoctorDetailsPage({this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Doctor Details',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        ),
        body: Center(
          child: Text('No Doctor Found!', style: textTheme.headlineSmall),
        ),
      );
    } else {
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
          child: DoctorCard(doctor: doctor!),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 220, 227, 255),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
              },
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
}
