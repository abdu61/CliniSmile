import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/services.dart';

class StaffBillingPage extends StatefulWidget {
  final Appointment appointment;
  final DatabaseService databaseService;

  const StaffBillingPage({
    Key? key,
    required this.appointment,
    required this.databaseService,
  }) : super(key: key);

  @override
  _StaffBillingPageState createState() => _StaffBillingPageState();
}

class _StaffBillingPageState extends State<StaffBillingPage> {
  double consultationFee = 0.0;
  Service? selectedService;
  List<Service> services = [];
  List<Map<String, dynamic>> otherCharges = [];
  String? paymentMethod;
  List<bool> isSelected = [false, false];

  @override
  void initState() {
    super.initState();
    if (widget.appointment.paymentMethod == 'Cash') {
      consultationFee = 5.0;
    }
    fetchServices();
  }

  Future<void> fetchServices() async {
    services = await widget.databaseService.getServices();
    setState(() {});
  }

  void addOtherCharge() async {
    final charge = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        double price = 0.0;
        return AlertDialog(
          title: Text('Add Other Charge'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () =>
                  Navigator.of(context).pop({'name': name, 'price': price}),
            ),
          ],
        );
      },
    );
    if (charge != null) {
      setState(() {
        otherCharges.add(charge);
      });
    }
  }

  double calculateTotal() {
    double total = consultationFee;
    if (selectedService != null) {
      total += selectedService!.price;
    }
    for (var charge in otherCharges) {
      total += charge['price'];
    }
    return total;
  }

  double calculateTax(double total) {
    return total * 0.1;
  }

  Future<void> processPayment() async {
    try {
      // Update the appointment with the new billing information
      Appointment updatedAppointment = Appointment(
        id: widget.appointment.id,
        doctorId: widget.appointment.doctorId,
        userId: widget.appointment.userId,
        start: widget.appointment.start,
        end: widget.appointment.end,
        status: widget.appointment.status,
        paymentMethod: paymentMethod ?? widget.appointment.paymentMethod,
        bookingTime: widget.appointment.bookingTime,
        consultationFee: consultationFee,
        userMode: widget.appointment.userMode,
        name: widget.appointment.name,
        phoneNumber: widget.appointment.phoneNumber,
        services: selectedService != null ? [selectedService!] : [],
        tax: calculateTax(calculateTotal()),
        totalAmount: calculateTotal() + calculateTax(calculateTotal()),
        otherCharges:
            otherCharges.map((charge) => Charge.fromFirestore(charge)).toList(),
        billedStatus: 'Paid',
      );

      // Save the updated appointment to the database
      await widget.databaseService.updateAppointment(updatedAppointment);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment processed successfully!')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = calculateTotal();
    double tax = calculateTax(total);
    double totalWithTax = total + tax;

    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(32.0),
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Billing Page',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16.0),
                Text(
                    'Consultation Fee: ${widget.appointment.paymentMethod == 'Cash' ? 'BD${consultationFee.toStringAsFixed(2)}' : 'Paid'}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 16.0),
                DropdownButton<Service>(
                  value: selectedService,
                  items: services.map((Service service) {
                    return DropdownMenuItem<Service>(
                      value: service,
                      child: Text(service.name, style: TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                  onChanged: (Service? newValue) {
                    setState(() {
                      selectedService = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Text('Total: BD${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16.0),
                Text('Tax: BD${tax.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16.0),
                Text('Total with Tax: BD${totalWithTax.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: addOtherCharge,
                  child: const Text('Add Other Charge',
                      style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 28.0),
                ToggleButtons(
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                          paymentMethod = buttonIndex == 0 ? 'Cash' : 'Card';
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  children: const <Widget>[
                    Text('Cash'),
                    Text('Card'),
                  ],
                ),
                const SizedBox(height: 28.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back', style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onPressed:
                        processPayment();
                      },
                      child: const Text('Process Payment',
                          style: TextStyle(fontSize: 20)),
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
