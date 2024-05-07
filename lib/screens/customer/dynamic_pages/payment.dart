import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/bottom_navbar_button.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatefulWidget {
  final Doctor? doctor;
  final String? userId;
  final DateTime date;
  final TimeOfDay time;

  PaymentPage(
      {this.doctor, this.userId, required this.date, required this.time});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Debit';
  final _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  Future<void> _pay() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Validate the payment information
      // TODO: Process the payment

      // If the payment is successful, book the appointment
      final start = DateTime(widget.date.year, widget.date.month,
          widget.date.day, widget.time.hour, widget.time.minute);
      // Assuming each appointment lasts 30 minutes
      final end = start.add(Duration(minutes: 30));

      // Check if the slot is already booked
      final snapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: widget.doctor!.id)
          .where('start', isEqualTo: start)
          .get();

      if (snapshot.docs.isEmpty) {
        await _appointmentsCollection.add({
          'doctorId': widget.doctor!.id,
          'userId': widget.userId,
          'start': start,
          'end': end,
          'status': 'Open',
          'paymentMethod': _paymentMethod,
          'bookingTime': DateTime.now(),
          'consultationFee': 5.0,
          'userMode': 'Online',
        });

        // Show a dialog that says "Appointment successful"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Appointment successful'),
              content:
                  const Text('Your appointment has been booked successfully.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop(); // Pop the dialog
                    }

                    int count = 0;
                    while (Navigator.of(context).canPop() && count < 3) {
                      Navigator.of(context)
                          .pop(); // Pop the current and previous pages
                      count++;
                    }
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show a dialog that says "Slot already booked"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Slot already booked'),
              content: const Text('Please select a different slot.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    // Pop the dialog
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: SimpleAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Payment method field
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: ['Debit', 'Credit'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _paymentMethod = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Consultation Fee: BD 5.0',
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarButtons(
        isEnabled: true,
        onPressed: _pay,
        buttonText: 'Pay',
      ),
    );
  }
}
