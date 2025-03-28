import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onPressed,
  });

  final String title;
  final String? action;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        if (action != null)
          TextButton(
            onPressed: onPressed,
            child: Text(
              action!,
              style: textTheme.bodyMedium!.copyWith(
                decoration: TextDecoration.underline,
                color: const Color(0xFFc42d5e),
              ),
            ),
          ),
      ],
    );
  }
}
