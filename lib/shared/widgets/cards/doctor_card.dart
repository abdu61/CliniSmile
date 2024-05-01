import 'package:dental_clinic/models/doctor.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    this.showAbout = true,
    this.showMoreInformation = true,
  });

  final Doctor doctor;
  final bool showAbout;
  final bool showMoreInformation;

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final moreInformation = [
      {
        'icon': Icons.account_circle_outlined,
        'label': 'Patients',
        'value': widget.doctor.reviewCount,
      },
      {
        'icon': Icons.star_border,
        'label': 'Years Experience',
        'value': widget.doctor.experience,
      },
      {
        'icon': Icons.favorite_border,
        'label': 'Rating',
        'value': widget.doctor.rating,
      },
    ];

    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.doctor.profileImageUrl,
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name,
                      style: textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        widget.doctor.category.name,
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onBackground.withOpacity(.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 32.0, color: colorScheme.surfaceVariant),

          // About
          ...widget.showAbout
              ? [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.doctor.bio,
                    maxLines: showAll ? null : 3,
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onBackground.withOpacity(.5),
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    onPressed: () {
                      setState(() {
                        showAll = !showAll;
                      });
                    },
                    child: Text(
                      showAll ? 'Show less' : 'Show all',
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.secondary,
                        decoration: TextDecoration.underline,
                        decorationColor: colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ]
              : [],

          // More information
          ...widget.showMoreInformation
              ? [
                  Row(
                    children: moreInformation
                        .map(
                          (e) => Expanded(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      const Color.fromARGB(255, 126, 156, 252),
                                  foregroundColor: colorScheme.onPrimary,
                                  child: Icon(
                                    e['icon'] as IconData,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  e['value'].toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyLarge!.copyWith(
                                      color: const Color(0xFFc42d5e),
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e['label'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )
                ]
              : []
        ],
      ),
    );
  }
}
