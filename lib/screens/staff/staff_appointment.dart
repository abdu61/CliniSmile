import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/models/health.dart';
import 'package:dental_clinic/screens/staff/dynamic_pages/add_appointment_dialog.dart';
import 'package:dental_clinic/screens/staff/staff_billing_page.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/DateTime%20pickers/date_selector.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/button_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StaffAppointment extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const StaffAppointment({
    super.key,
    required this.authService,
    required this.databaseService,
  });

  @override
  State<StaffAppointment> createState() => _StaffAppointmentState();
}

class _StaffAppointmentState extends State<StaffAppointment> {
  List<Appointment> appointments = [];
  DateTime _selectedMonth = DateTime.now();
  DateTime _date = DateTime.now();
  bool _dateSelected = true;
  String name = '';
  String phoneNumber = '';
  Map<String, Doctor?> doctorDetails = {};
  Map<String, String?> userDetails = {};
  List<Doctor> doctors = [];
  String selectedDoctorId = '';
  String billedStatus = '';

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
  }

  Future<void> fetchAppointments() async {
    appointments = await widget.databaseService.getAppointmentsByDate(_date);
    appointments.sort((a, b) =>
        a.start.compareTo(b.start)); // Sort appointments by start time

    // Get a list of all unique doctor IDs
    var doctorIds = appointments.map((a) => a.doctorId).toSet().toList();

    // Fetch doctor details for each unique doctor ID
    for (var doctorId in doctorIds) {
      try {
        Doctor doctor = await widget.databaseService.getDoctorById(doctorId);
        doctorDetails[doctorId] = doctor;
      } catch (e) {
        print('Failed to fetch doctor details: $e');
      }
    }

    // Get a list of all unique user IDs
    var userIds = appointments.map((a) => a.userId).toSet().toList();

    // Fetch user details for each unique user ID
    for (var userId in userIds) {
      if (userId != null) {
        // Check if userId is not null
        try {
          DocumentSnapshot userDoc =
              await widget.databaseService.getUserById(userId);
          String userName = (userDoc.data() as Map<String, dynamic>)?['name'] ??
              'Unknown'; // Get the user's name
          userDetails[userId] =
              userName; // Assign the user's name to userDetails[userId]
        } catch (e) {
          print('Failed to fetch user details: $e');
          // If failed to fetch user details, use the name field from the Appointment object
          for (var appointment
              in appointments.where((a) => a.userId == userId)) {
            userDetails[userId] = appointment.name;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of days in the selected month
    final daysInMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;

    final dateList = SizedBox(
      height: 130, // Adjust this value as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          // Use the selected month and index to create the date
          final date =
              DateTime(_selectedMonth.year, _selectedMonth.month, index + 1);

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
            },
          );
        },
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                          _selectedMonth.year, _selectedMonth.month - 1);
                    });
                  },
                ),
                const SizedBox(width: 80),
                Text(
                  DateFormat('MMMM yyyy').format(_selectedMonth),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 80),
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
            const SizedBox(height: 20),
            dateList,
            const SizedBox(height: 30), // Add a SizedBox for spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Appointments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Reset the selected month and date to today
                    setState(() {
                      _selectedMonth = DateTime.now();
                      _date = DateTime.now();
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AddAppointmentDialog(
                          databaseService: widget.databaseService,
                          onAddAppointment: (appointment) async {
                            await widget.databaseService
                                .addAppointment(appointment);
                            await fetchAppointments();
                            setState(() {});
                          },
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 126, 156, 252),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 24.0),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 14),
                      Text(
                        'Add Appointment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: FutureBuilder(
                future: fetchAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loading(); // Show a loading spinner while waiting for the data
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Show an error message if something went wrong
                  } else {
                    return ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        Doctor? doctor =
                            doctorDetails[appointments[index].doctorId];
                        String? userName =
                            userDetails[appointments[index].userId];
                        return ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth:
                                  600), // Limit the maximum width of the card
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Patient Name: ${userName ?? 'Unknown'}',
                                          style: const TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight
                                                  .bold), // Make the user name more focused
                                        ),
                                        Text('Doctor: ${doctor?.name}'),
                                        Text(
                                            'Category: ${doctor?.category.name}'),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    DateFormat('hh:mm a')
                                        .format(appointments[index].start),
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    'Status: ${appointments[index].billedStatus}',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            appointments[index].billedStatus ==
                                                    'Paid'
                                                ? Colors.green
                                                : Colors.red),
                                  ),
                                  const SizedBox(width: 20.0),
                                  CustomElevatedButton(
                                    onPressed: () async {
                                      final TextEditingController _controller =
                                          TextEditingController();
                                      return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Add Health Record'),
                                            content: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: _controller,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "Enter health record details"),
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Submit'),
                                                onPressed: () async {
                                                  final String details =
                                                      _controller.text;
                                                  final String userId =
                                                      appointments[index]
                                                              .userId ??
                                                          '';
                                                  if (userId.isNotEmpty &&
                                                      details.isNotEmpty) {
                                                    HealthRecord record =
                                                        HealthRecord(
                                                      id: '', // Generate an ID for the record
                                                      userId: userId,
                                                      details: details,
                                                      date: DateTime.now(),
                                                    );
                                                    await widget.databaseService
                                                        .addHealthRecord(
                                                            record);
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    // Handle the error when userId or details is empty
                                                    print(
                                                        'Error: User ID or details is empty');
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    text: 'Add Record',
                                  ),
                                  const SizedBox(width: 20.0),

                                  // Add a button to bill the customer
                                  CustomElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StaffBillingPage(
                                            appointment: appointments[index],
                                            databaseService:
                                                widget.databaseService,
                                          ),
                                        ),
                                      );
                                    },
                                    text: 'Bill Customer',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      await widget.databaseService
                                          .deleteAppointmentById(
                                              appointments[index].id);
                                      setState(() {
                                        fetchAppointments();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
