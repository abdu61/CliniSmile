import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/doctor_details.dart';
import 'package:flutter/material.dart';

class DoctorListTile extends StatelessWidget {
  DoctorListTile({
    super.key,
    required this.doctor,
    required this.userId,
    this.userRole,
  });

  final Doctor doctor;
  final String userId;
  String? userRole;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
          // Add navigation
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorDetailsPage(doctor: doctor, userId: userId),
              ),
            );
          },
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              doctor.profileImageUrl,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            doctor.name,
            style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4.0),
              Text(
                doctor.category.name,
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.star,
                      color: Color.fromRGBO(255, 204, 128, 1), size: 16),
                  const SizedBox(width: 4.0),
                  Text(
                    doctor.rating.toString(),
                    style: textTheme.bodySmall!.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.work, color: colorScheme.tertiary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${doctor.experience.toString()} years',
                    style: textTheme.bodySmall!.copyWith(
                      color: colorScheme.onBackground.withOpacity(.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailsPage(
                      doctor: doctor, userId: userId, userRole: userRole ?? ''),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 126, 156, 252),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: const Text('Book Now'),
          ),
        ),
        Container(
          height: 1.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.grey,
                Colors.transparent,
              ],
            ),
          ),
        )
      ],
    );
  }
}
