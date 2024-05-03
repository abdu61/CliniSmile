import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/payment.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/widgets/DateTime%20pickers/date_selector.dart';
import 'package:dental_clinic/shared/widgets/DateTime%20pickers/time_selector.dart';
import 'package:dental_clinic/shared/widgets/cards/doctor_card.dart';
import 'package:dental_clinic/shared/widgets/core.dart/bottom_navbar_button.dart';
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

  TimeOfDay _parseTime(String time) {
    final split = time.split(':');
    if (split.length != 2) {
      throw FormatException(
          'Invalid time format. Expected "HH:mm", got "$time"');
    }
    try {
      return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
    } catch (e) {
      throw FormatException(
          'Invalid time format. Expected "HH:mm", got "$time"');
    }
  }

  List<TimeOfDay> _generateTimeSlots(
      List<String>? workingHours, List<String>? breakHours) {
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

    TimeOfDay? breakStartTime;
    TimeOfDay? breakEndTime;
    int? breakStartMinutes;
    int? breakEndMinutes;

    if (breakHours != null && breakHours.length == 2) {
      breakStartTime = _parseTime(breakHours[0]);
      breakEndTime = _parseTime(breakHours[1]);

      breakStartMinutes = breakStartTime.hour * 60 + breakStartTime.minute;
      breakEndMinutes = breakEndTime.hour * 60 + breakEndTime.minute;
    }

    for (var i = startMinutes; i < endMinutes; i += 30) {
      // Skip the time slot if it falls within the break hours
      if (breakStartMinutes != null &&
          breakEndMinutes != null &&
          i >= breakStartMinutes &&
          i < breakEndMinutes) continue;

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
              TimeOfDay.fromDateTime(appointment.start.toLocal()))
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

        // Return a DateSelector widget
        return DateSelector(
          date: date,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _date = DateTime(date.year, date.month, date.day, 0, 0, 0);
              _dateSelected = true;
            });

            // Fetch appointments for the selected date
            _fetchAppointments();
          },
        );
      },
    );

    // Generate time slots for the selected date
    List<Widget> timeList = _dateSelected &&
            widget.doctor!.workingHours[_weekdayToString(_date.weekday)] != null
        ? _generateTimeSlots(
                widget.doctor!.workingHours[_weekdayToString(_date.weekday)]!,
                widget.doctor!.breakHours[_weekdayToString(_date.weekday)]!)
            .map((time) {
            final isBooked = _isTimeBooked(time);

            // Return a TimeSelector widget
            return TimeSelector(
              time: time,
              isBooked: isBooked,
              isSelected: _time == time,
              onTap: () {
                setState(() {
                  _time = time;
                });
              },
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
      bottomNavigationBar: BottomNavBarButtons(
        isEnabled: _dateSelected && _time != null,
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => PaymentPage(
                doctor: widget.doctor,
                userId: widget.userId,
                date: _date,
                time: _time!,
              ),
              transitionDuration: const Duration(microseconds: 200000),
              transitionsBuilder: (context, animation, animationTime, child) {
                animation =
                    CurvedAnimation(parent: animation, curve: Curves.easeIn);
                return SlideTransition(
                  position: Tween(
                          begin: const Offset(1.0, 0.0),
                          end: const Offset(0.0, 0.0))
                      .animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        buttonText: 'Next',
      ),
    );
  }
}
