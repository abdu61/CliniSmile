import 'package:flutter/material.dart';
import 'package:flutter_jap_icons/medical_icons_icons.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
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
            child: Icon(icon),
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
