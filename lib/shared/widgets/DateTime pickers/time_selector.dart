import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final TimeOfDay time;
  final bool isBooked;
  final bool isSelected;
  final Function onTap;

  TimeSelector(
      {required this.time,
      required this.isBooked,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBooked ? null : () => onTap(),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey[400]
              : isSelected
                  ? const Color.fromARGB(255, 126, 156, 252)
                  : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          time.format(context),
          style: TextStyle(
            color: isBooked
                ? Colors.grey[300]
                : isSelected
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
    );
  }
}
