import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final String categoryId;
  final List<String> packageIds;
  final List<String> workingHourIds;
  final double rating;
  final int reviewCount;
  final int patientCount;

  Doctor({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.categoryId,
    required this.packageIds,
    required this.workingHourIds,
    required this.rating,
    required this.reviewCount,
    required this.patientCount,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Doctor(
      id: doc.id,
      name: data['name'],
      bio: data['bio'],
      profileImageUrl: data['profileImageUrl'],
      categoryId: data['categoryId'],
      packageIds: List<String>.from(data['packageIds']),
      workingHourIds: List<String>.from(data['workingHourIds']),
      rating: data['rating'],
      reviewCount: data['reviewCount'],
      patientCount: data['patientCount'],
    );
  }
}
