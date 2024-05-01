import 'package:dental_clinic/models/doctor.dart';
import 'package:flutter/material.dart';

class DoctorListTile extends StatelessWidget {
  const DoctorListTile({
    super.key,
    required this.doctor,
  });

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
        // Add navigation
        onTap: () {},
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
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 136, 164, 255),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          child: const Text('Book Now'),
        ));
  }
}
