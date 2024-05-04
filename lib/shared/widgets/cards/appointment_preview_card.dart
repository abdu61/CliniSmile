import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPreviewCard extends StatelessWidget {
  const AppointmentPreviewCard({
    Key? key,
    this.appointment,
  }) : super(key: key);

  final Appointment? appointment;

  Future<Doctor> getDoctor(String doctorId, String uid) {
    print('Getting doctor with ID: $doctorId'); // Debug print statement
    return DatabaseService(uid: uid).getDoctorById(doctorId);
  }

  @override
  Widget build(BuildContext context) {
    print('Appointment: $appointment');
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 126, 156, 252),
                Color.fromARGB(255, 168, 188, 255),
              ],
            ),
          ),
          child: appointment == null
              ? SizedBox(
                  height: 90,
                  child: Center(
                    child: Text(
                      'No appointment yet',
                      style: textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : FutureBuilder<Doctor>(
                  future: getDoctor(appointment!.doctorId, 'uid'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    }

                    if (snapshot.hasError) {
                      print(
                          'Error getting doctor: ${snapshot.error}'); // Debug print statement
                      return Text('Error: ${snapshot.error}');
                    }

                    final doctor = snapshot.data;
                    return Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                doctor?.profileImageUrl ?? 'default_image_url',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    20), // Add some space between the image and the text
                            Expanded(
                              // Use Expanded to prevent overflow of long text
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor?.name ?? 'No name',
                                    style: textTheme.titleLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doctor?.category.name ?? 'No category',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  DateFormat('EEE, MMM d, y')
                                      .format(appointment!.start),
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Icon(Icons.access_time,
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  '${DateFormat.jm().format(appointment!.start)}',
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
        Container(
          height: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.25),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
        Container(
          height: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.15),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
