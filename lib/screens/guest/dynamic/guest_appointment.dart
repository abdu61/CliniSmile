import 'package:dental_clinic/screens/customer/dynamic_pages/book_appointment_pick.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/bottom_navbar_button.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/models/doctor.dart';

class GuestAppointmentPage extends StatefulWidget {
  final Doctor doctor;

  const GuestAppointmentPage({Key? key, required this.doctor})
      : super(key: key);

  @override
  _GuestAppointmentPageState createState() => _GuestAppointmentPageState();
}

class _GuestAppointmentPageState extends State<GuestAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Guest Appointment'),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length != 8) {
                  return 'Phone number should be 8 digits';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBarButtons(
        isEnabled: _formKey.currentState?.validate() ?? false,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookAppointmentPage(
                  doctor: widget.doctor,
                  name: name,
                  phoneNumber: phoneNumber,
                  isStaff: true,
                ),
              ),
            );
            if (result != null && result) {
              Navigator.pop(context);
            }
          }
        },
        buttonText: 'Next',
      ),
    );
  }
}
