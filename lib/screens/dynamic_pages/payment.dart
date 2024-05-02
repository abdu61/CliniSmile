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
      final end = start.add(
          Duration(minutes: 30)); // Assuming each appointment lasts 30 minutes

      await _appointmentsCollection.add({
        'doctorId': widget.doctor!.id,
        'userId': widget.userId,
        'start': start,
        'end': end,
        'paymentMethod': _paymentMethod,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
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

              // Pay button
              ElevatedButton(
                onPressed: _pay,
                child: Text('Pay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
