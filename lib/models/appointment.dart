import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/services.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String? userId;
  final DateTime start;
  final DateTime end;
  final String status;
  final String paymentMethod;
  final DateTime bookingTime;
  final double consultationFee;
  final String userMode;
  final String? name;
  final String? phoneNumber;
  final List<Service> services;
  double tax;
  double totalAmount;
  String billedStatus;
  final List<Charge> otherCharges;

  Appointment({
    this.id = '',
    required this.doctorId,
    required this.userId,
    required this.start,
    required this.end,
    this.status = 'Open',
    required this.paymentMethod,
    required this.bookingTime,
    this.consultationFee = 0.0,
    this.userMode = 'Online',
    this.name,
    this.phoneNumber,
    this.services = const [],
    this.tax = 0.0,
    this.otherCharges = const [],
    this.totalAmount = 0.0,
    this.billedStatus = 'Unbilled',
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    var serviceList = data['services'] as List;
    List<Service> services =
        serviceList.map((i) => Service.fromFirestore(i)).toList();
    var chargeList = data['otherCharges'] as List;
    List<Charge> otherCharges =
        chargeList.map((i) => Charge.fromFirestore(i)).toList();

    return Appointment(
      id: doc.id,
      doctorId: data['doctorId'] as String,
      userId: data['userId'] as String?,
      start: (data['start'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      end: (data['end'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      status: data['status'] as String,
      paymentMethod: data['paymentMethod'] as String,
      bookingTime:
          (data['bookingTime'] as Timestamp?)?.toDate() ?? DateTime(1970, 1, 1),
      consultationFee: (data['consultationFee'] as num?)?.toDouble() ?? 0.0,
      userMode: data['userMode'] as String,
      name: data['name'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      services: services,
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      otherCharges: otherCharges,
      billedStatus: data['billedStatus'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'userId': userId,
      'start': start,
      'end': end,
      'status': status,
      'paymentMethod': paymentMethod,
      'bookingTime': bookingTime,
      'consultationFee': consultationFee,
      'userMode': userMode,
      'name': name,
      'phoneNumber': phoneNumber,
      'services': services.map((service) => service.toMap()).toList(),
      'tax': tax,
      'totalAmount': totalAmount,
      'otherCharges': otherCharges.map((charge) => charge.toMap()).toList(),
      'billedStatus': billedStatus,
    };
  }
}

class Charge {
  final String name;
  final double price;

  Charge({required this.name, required this.price});

  factory Charge.fromFirestore(Map<String, dynamic> data) {
    return Charge(
      name: data['name'] as String,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
