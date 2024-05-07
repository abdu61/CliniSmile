import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String doctorId;
  final String userId;
  final DateTime start;
  final DateTime end;
  final String status;
  final String paymentMethod;
  final DateTime bookingTime;
  final double consultationFee;
  final String userMode;
  final String? name;
  final String? phoneNumber;

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
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      doctorId: data['doctorId'] as String,
      userId: data['userId'] as String,
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
    );
  }
}
