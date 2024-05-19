import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/doctor.dart'; // Import your Doctor model
import 'package:dental_clinic/screens/customer/dynamic_pages/update_appointment.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final AuthService auth;
  final DatabaseService db;

  AppointmentPage({Key? key, required this.auth, required this.db})
      : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.auth.currentUser == null) {
      throw StateError('No current user');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Appointments'),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8.0),
                  selectedColor: Colors.white,
                  color: Colors.black,
                  fillColor: const Color.fromARGB(255, 126, 156, 252),
                  selectedBorderColor: const Color.fromARGB(255, 126, 156, 252),
                  onPressed: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  isSelected:
                      List.generate(3, (index) => index == _selectedIndex),
                  children: const <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
                      child: Text(
                        'All',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight
                                .bold), // Make the font bigger and bold
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
                      child: Text(
                        'Open',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight
                                .bold), // Make the font bigger and bold
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
                      child: Text(
                        'Closed',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight
                                .bold), // Make the font bigger and bold
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.db
                  .getAppointmentsByUserid(widget.auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                }

                final docs = snapshot.data?.docs ?? [];
                final appointments =
                    docs.map((doc) => Appointment.fromFirestore(doc)).toList();

                // Filter appointments based on the selected status
                final filteredAppointments = appointments.where((appointment) {
                  switch (_selectedIndex) {
                    case 0: // All
                      return true;
                    case 1: // Open
                      return appointment.status == 'Open';
                    case 2: // Closed
                      return appointment.status == 'Closed';
                    default:
                      return false;
                  }
                }).toList();

                return ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = filteredAppointments[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: ListTile(
                            leading: FutureBuilder<Doctor>(
                              future:
                                  widget.db.getDoctorById(appointment.doctorId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Icon(Icons.error);
                                }
                                final doctor = snapshot.data;
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    doctor?.profileImageUrl ?? '',
                                    width: 60.0,
                                    height: 60.0,
                                    fit: BoxFit.fill,
                                  ),
                                );
                              },
                            ),
                            title: FutureBuilder<Doctor>(
                              future:
                                  widget.db.getDoctorById(appointment.doctorId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }
                                if (snapshot.hasError) {
                                  return Text('Error');
                                }
                                final doctor = snapshot.data;
                                return RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${doctor?.name ?? ''}\n',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: doctor?.category.name ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10.0,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            subtitle: Text(
                              'On ${DateFormat('dd-MM-yyyy').format(appointment.start)}\nat ${DateFormat('HH:mm:ss').format(appointment.start)}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Wrap(
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.edit),
                                          title: const Text('Update'),
                                          onTap: () {
                                            // Navigate to the update appointment page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateAppointmentPage(
                                                        appointment:
                                                            appointment),
                                              ),
                                            );
                                            // Navigate to the update appointment page
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete),
                                          title: const Text('Delete'),
                                          onTap: () {
                                            print(
                                                'Delete button tapped, appointment id: ${appointment.id}');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Delete appointment'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this appointment?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () async {
                                                        try {
                                                          await widget.db
                                                              .deleteAppointmentById(
                                                                  appointment
                                                                      .id);
                                                          if (mounted) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the bottom sheet
                                                          }
                                                        } catch (e) {
                                                          print(
                                                              'Error deleting appointment: $e');
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
