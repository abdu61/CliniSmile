import 'package:flutter/material.dart';

class BottomNavBarButtons extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final String buttonText;

  BottomNavBarButtons({
    required this.isEnabled,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BottomAppBar(
      color: const Color.fromARGB(255, 220, 227, 255),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          child: Text(
            buttonText,
            style: textTheme.labelLarge!.copyWith(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
