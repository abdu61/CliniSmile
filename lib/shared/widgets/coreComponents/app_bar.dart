import 'package:flutter/material.dart';

// App Bar with Just Title along with styling
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  SimpleAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      title: Text(
        title,
        style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 220, 227, 255),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
