import 'package:cloud_firestore/cloud_firestore.dart';

enum ConsultationMode { online, offline }

class DoctorPackage {
  final String id;
  final String doctorId;
  final String packageName;
  final String description;
  final int duration;
  final double price;
  final ConsultationMode consultationMode;

  DoctorPackage({
    required this.id,
    required this.doctorId,
    required this.packageName,
    required this.description,
    required this.duration,
    required this.price,
    required this.consultationMode,
  });

  factory DoctorPackage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return DoctorPackage(
      id: doc.id,
      doctorId: data['doctorId'],
      packageName: data['packageName'],
      description: data['description'],
      duration: data['duration'],
      price: data['price'],
      consultationMode: data['consultationMode'] == 'online'
          ? ConsultationMode.online
          : ConsultationMode.offline,
    );
  }
}
