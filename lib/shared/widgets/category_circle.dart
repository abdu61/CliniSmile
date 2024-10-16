import 'package:flutter/material.dart';
import 'package:flutter_jap_icons/medical_icons_icons.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    Key? key,
    required this.iconData, // Change this to IconData
    required this.label,
    this.onTap,
  }) : super(key: key);

  final IconData iconData; // Change this to IconData
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color.fromARGB(255, 220, 227, 255),
            foregroundColor: Colors.black,
            child: Icon(iconData), // Use the iconData here
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

IconData getIcon(String iconName) {
  switch (iconName) {
    case 'dental':
      return MedicalIcons.dental;
    case 'general':
      return MedicalIcons.health_services;
    case 'dermatology':
      return MedicalIcons.dermatology;
    case 'endodontics':
      return MedicalIcons.i_emergency;
    // Add more cases for each icon in the MedicalIcons class
    default:
      throw ArgumentError('Unknown icon name: $iconName');
  }
}
