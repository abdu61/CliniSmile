import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/button_style.dart';
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
        status: 'Closed',
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
          margin: const EdgeInsets.all(32.0),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Billing Page',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16.0),
                Text(
                    'Consultation Fee: ${widget.appointment.paymentMethod == 'Cash' ? 'BD${consultationFee.toStringAsFixed(2)}' : 'Paid'}',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 16.0),
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
                CustomElevatedButton(
                  onPressed: addOtherCharge,
                  text: 'Add Other Charge',
                ),
                const SizedBox(height: 28.0),
                ToggleButtons(
                  isSelected: [
                    paymentMethod == 'Cash',
                    paymentMethod == 'Card'
                  ],
                  onPressed: (int index) {
                    setState(() {
                      paymentMethod = index == 0 ? 'Cash' : 'Card';
                    });
                  },
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color.fromARGB(255, 0, 0, 0), // Default color
                  selectedColor: Colors.white,
                  fillColor: const Color.fromARGB(255, 126, 156, 252),
                  borderColor: const Color.fromARGB(255, 126, 156, 252),
                  selectedBorderColor: const Color.fromARGB(255, 126, 156, 252),
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text('Cash',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Text('Card',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    ),
                  ],
                ),
                const SizedBox(height: 28.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'Back',
                      color: const Color.fromARGB(255, 190, 190, 190),
                    ),
                    CustomElevatedButton(
                      onPressed: processPayment,
                      text: 'Process Payment',
                    )
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
