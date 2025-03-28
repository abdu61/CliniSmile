import 'package:dental_clinic/screens/customer/dynamic_pages/book_appointment_pick.dart';
import 'package:dental_clinic/screens/guest/dynamic/guest_appointment.dart';
import 'package:dental_clinic/shared/widgets/cards/doctor_card.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/bottom_navbar_button.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/models/doctor.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor? doctor;
  final String? userId;
  final String? userRole;

  DoctorDetailsPage({this.doctor, this.userId, this.userRole});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (doctor == null) {
      return Scaffold(
        appBar: SimpleAppBar(title: 'Doctor Details'),
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
        bottomNavigationBar: BottomNavBarButtons(
          isEnabled: true,
          onPressed: () {
            if (doctor != null) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => userRole ==
                          'guest'
                      ? GuestAppointmentPage(doctor: doctor!)
                      : BookAppointmentPage(doctor: doctor!, userId: userId),
                  transitionDuration: const Duration(microseconds: 200000),
                  transitionsBuilder:
                      (context, animation, animationTime, child) {
                    animation = CurvedAnimation(
                        parent: animation, curve: Curves.easeIn);
                    return SlideTransition(
                      position: Tween(
                              begin: const Offset(1.0, 0.0),
                              end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            } else {
              // Handle the situation when doctor is null
              print('Error: doctor is null');
            }
          },
          buttonText: 'Book Appointment',
        ),
      );
    }
  }
}
