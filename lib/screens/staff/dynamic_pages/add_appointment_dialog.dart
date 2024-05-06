import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/book_appointment_pick.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAppointmentDialog extends StatefulWidget {
  final DatabaseService databaseService;
  final Function(Appointment) onAddAppointment;

  AddAppointmentDialog(
      {required this.databaseService, required this.onAddAppointment});

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phoneNumber = '';
  String selectedDoctorId = '';
  List<Doctor> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    doctors = await widget.databaseService.getDoctors();
    print(doctors);
    if (doctors.isNotEmpty) {
      setState(() => selectedDoctorId = doctors[0].id);
    }
  }

  @override
  Widget build(BuildContext context) {
    Doctor? selectedDoctor;
    for (var doctor in doctors) {
      if (doctor.id == selectedDoctorId) {
        selectedDoctor = doctor;
        break;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onChanged: (val) {
                    setState(() => phoneNumber = val);
                  },
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Phone Number',
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedDoctorId,
                  onChanged: (val) {
                    setState(() => selectedDoctorId = val ?? '');
                  },
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Doctor',
                  ),
                  items: doctors.map((Doctor doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.id,
                      child: Text(doctor.name),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Doctor? selectedDoctor;
                          for (var doctor in doctors) {
                            if (doctor.id == selectedDoctorId) {
                              selectedDoctor = doctor;
                              break;
                            }
                          }
                          if (selectedDoctor != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookAppointmentPage(doctor: selectedDoctor),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Next'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
