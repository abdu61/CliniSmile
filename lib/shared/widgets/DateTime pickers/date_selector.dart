import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final Function onTap;

  DateSelector(
      {required this.date, required this.isSelected, required this.onTap});

  String _weekdayToAbbreviatedString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        throw Exception('Invalid weekday: $weekday');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 60.0,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 126, 156, 252)
              : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              _weekdayToAbbreviatedString(date.weekday),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
