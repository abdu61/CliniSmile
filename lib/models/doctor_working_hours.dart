import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorWorkingHours {
  final String id;
  final String doctorId;
  final DateTime startTime;
  final DateTime endTime;
  final String dayOfWeek;

  DoctorWorkingHours({
    required this.id,
    required this.doctorId,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
  });

  factory DoctorWorkingHours.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return DoctorWorkingHours(
      id: doc.id,
      doctorId: data['doctorId'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      dayOfWeek: data['dayOfWeek'],
    );
  }
}
