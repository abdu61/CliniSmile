import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecord {
  final String id;
  final String userId;
  final String details;
  final DateTime date;

  HealthRecord({
    required this.id,
    required this.userId,
    required this.details,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'details': details,
      'date': date,
    };
  }

  static HealthRecord fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return HealthRecord(
      id: doc.id,
      userId: data['userId'] ?? '',
      details: data['details'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
