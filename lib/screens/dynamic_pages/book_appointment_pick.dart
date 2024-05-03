import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/screens/dynamic_pages/payment.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/widgets/cards/doctor_card.dart';
import 'package:flutter/material.dart';

class BookAppointmentPage extends StatefulWidget {
  final Doctor? doctor;
  final String? userId;

  BookAppointmentPage({this.doctor, this.userId});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _date = DateTime.now();
  TimeOfDay? _time;
  bool _dateSelected = false;
  List<TimeOfDay> _bookedTimes = [];

  // Add your database service instance
  final DatabaseService _databaseService = DatabaseService(uid: 'uid');

  String _weekdayToString(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        throw Exception('Invalid weekday: $weekday');
    }
  }

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

  TimeOfDay _parseTime(String time) {
    final split = time.split(':');
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  List<TimeOfDay> _generateTimeSlots(List<String>? workingHours) {
    if (workingHours == null || workingHours.isEmpty) {
      return <TimeOfDay>[]; // Return an empty list if the doctor is not available
    }

    // Ensure there are exactly two elements in workingHours before proceeding
    if (workingHours.length != 2) {
      return <TimeOfDay>[]; // Return an empty list if workingHours does not contain exactly two elements
    }

    final startTime = _parseTime(workingHours[0]);
    final endTime = _parseTime(workingHours[1]);

    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    final timeSlots = <TimeOfDay>[];

    for (var i = startMinutes; i < endMinutes; i += 30) {
      final nextTime = TimeOfDay(hour: i ~/ 60, minute: i % 60);
      timeSlots.add(nextTime);
    }

    return timeSlots;
  }

  // Fetch appointments for the selected doctor and date
  void _fetchAppointments() async {
    final appointments = await _databaseService.getAppointmentsByDoctorAndDate(
      widget.doctor!.id,
      _date,
    );

    setState(() {
      _bookedTimes = appointments
          .map((appointment) =>
              TimeOfDay.fromDateTime(appointment.date.toLocal()))
          .toList();
    });
  }

  bool _isTimeBooked(TimeOfDay time) {
    return _bookedTimes.any((bookedTime) =>
        bookedTime.hour == time.hour && bookedTime.minute == time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final dateList = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemBuilder: (context, index) {
        final date = DateTime.now().add(Duration(days: index));
        final isSelected = _dateSelected &&
            _date.day == date.day &&
            _date.month == date.month &&
            _date.year == date.year;

        return GestureDetector(
          onTap: () {
            setState(() {
              _date = DateTime(date.year, date.month, date.day, 0, 0, 0);
              _dateSelected = true;
            });

            // Fetch appointments for the selected date
            _fetchAppointments();
          },
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
      },
    );

    List<Widget> timeList = _dateSelected &&
            widget.doctor!.workingHours[_weekdayToString(_date.weekday)] != null
        ? _generateTimeSlots(
                widget.doctor!.workingHours[_weekdayToString(_date.weekday)]!)
            .map((time) {
            final isBooked = _isTimeBooked(time);

            return GestureDetector(
              onTap: isBooked
                  ? null
                  : () {
                      setState(() {
                        _time = time;
                      });
                    },
              child: Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isBooked
                      ? Colors.grey[400]
                      : _time == time
                          ? const Color.fromARGB(255, 126, 156, 252)
                          : const Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  time.format(context),
                  style: TextStyle(
                    color: isBooked
                        ? Colors.grey[300]
                        : _time == time
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),
            );
          }).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DoctorCard(
              doctor: widget.doctor!,
              showAbout: false,
              showMoreInformation: false,
            ),
            // Date list
            SizedBox(
              height: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Expanded(child: dateList),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
            // Time list
            if (timeList.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    const Text(
                      'Select Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: Wrap(
                        children: timeList,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 220, 227, 255),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _dateSelected && _time != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            doctor: widget.doctor,
                            userId: widget.userId,
                            date: _date,
                            time: _time!,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Next',
                style: textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            )),
      ),
    );
  }
}
