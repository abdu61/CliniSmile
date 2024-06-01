import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/payment.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/widgets/DateTime%20pickers/date_selector.dart';
import 'package:dental_clinic/shared/widgets/DateTime%20pickers/time_selector.dart';
import 'package:dental_clinic/shared/widgets/cards/doctor_card.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/bottom_navbar_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  final Doctor? doctor;
  final String? userId;
  final String? name;
  final String? phoneNumber;
  final bool? isStaff;

  BookAppointmentPage(
      {this.doctor, this.userId, this.name, this.phoneNumber, this.isStaff});
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _date = DateTime.now();
  TimeOfDay? _time;
  bool _dateSelected = false;
  List<TimeOfDay> _bookedTimes = [];
  DateTime _selectedMonth = DateTime.now();
  final DatabaseService _databaseService = DatabaseService(uid: 'uid');

  // Converts weekday number to string
  String _weekdayToString(int weekday) {
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  // Parses time from string to TimeOfDay
  TimeOfDay _parseTime(String time) {
    final split = time.split(':');
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  // Generates available time slots
  List<TimeOfDay> _generateTimeSlots(
      List<String>? workingHours, List<String>? breakHours) {
    if (workingHours == null || workingHours.length != 2) {
      return <TimeOfDay>[]; // Return an empty list if the doctor is not available
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

  // Book Appointment function for Staff Appointments
  void _bookAppointment() async {
    if (_time != null) {
      // Create a new Appointment object
      Appointment appointment = Appointment(
        doctorId: widget.doctor!.id,
        userId: '',
        start: DateTime(
            _date.year, _date.month, _date.day, _time!.hour, _time!.minute),
        end: DateTime(
                _date.year, _date.month, _date.day, _time!.hour, _time!.minute)
            .add(Duration(minutes: 30)),
        status: 'Open',
        paymentMethod: 'Cash', // Set this to the appropriate value
        bookingTime: DateTime.now(),
        consultationFee: 0.0, // Set this to the appropriate value
        userMode: 'Offline',
        name: widget.name,
        phoneNumber: widget.phoneNumber,
      );

      try {
        // Add the appointment to the database
        await _databaseService.addAppointment(appointment);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );

        // Navigate back to the previous page
        Navigator.pop(context);
      } catch (e) {
        // Show a failure message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: $e')),
        );
      }
    } else {
      // Handle the case where _time is null
      print('Time is not selected');
      // Show a failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Time is not selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of days in the selected month
    final daysInMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

    final dateList = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        // Use the selected month and index to create the date
        final date =
            DateTime(_selectedMonth.year, _selectedMonth.month, index + 1);

        // Only show dates from the current day forward
        if (date.isBefore(DateTime.now()) && date.day != DateTime.now().day) {
          return Container(); // Return an empty container for past dates
        }

        final isSelected = _dateSelected &&
            _date.day == date.day &&
            _date.month == date.month &&
            _date.year == date.year;

        // Return a DateSelector widget
        return DateSelector(
          date: date,
          isSelected: isSelected,
          onTap: () {
            // Only allow selection if the date is today or in the future
            if (date.isAfter(DateTime.now()) ||
                date.day == DateTime.now().day) {
              setState(() {
                _date = DateTime(date.year, date.month, date.day, 0, 0, 0);
                _dateSelected = true;
              });

              // Fetch appointments for the selected date
              _fetchAppointments();
            }
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
      appBar: SimpleAppBar(title: 'Book Appointment'),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DoctorCard(
                    doctor: widget.doctor!,
                    showAbout: false,
                    showMoreInformation: false,
                  ),
                  // Add a row for month selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed:
                            _selectedMonth.month == DateTime.now().month &&
                                    _selectedMonth.year == DateTime.now().year
                                ? null
                                : () {
                                    setState(() {
                                      _selectedMonth = DateTime(
                                          _selectedMonth.year,
                                          _selectedMonth.month - 1);
                                    });
                                  },
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedMonth),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                                _selectedMonth.year, _selectedMonth.month + 1);
                          });
                        },
                      ),
                    ],
                  ),
                  // Date list
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: kIsWeb ? 140 : 125,
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
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarButtons(
        isEnabled: _dateSelected && _time != null,
        onPressed: () {
          if (widget.isStaff == true) {
            // Book the appointment directly
            // You'll need to implement the _bookAppointment function
            _bookAppointment();
          } else {
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
          }
        },
        buttonText: widget.isStaff == true ? 'Book Appointment' : 'Next',
      ),
    );
  }
}
