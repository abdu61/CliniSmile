import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/categories.dart';

class Doctor {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final Category category;
  final double rating;
  final int reviewCount;
  final int experience;
  final Map<String, List<String>> workingHours;
  final Map<String, List<String>> breakHours; // New field

  Doctor({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.experience = 0,
    required this.workingHours,
    required this.breakHours, // New field
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc, Category category) {
    Map data = doc.data() as Map;
    Map<String, List<String>> workingHours = {};
    Map<String, List<String>> breakHours = {}; // New field

    if (data.containsKey('workingHours')) {
      try {
        workingHours = Map<String, List<String>>.from(data['workingHours']);
      } catch (e) {
        print('Error parsing workingHours: $e');
      }
    }

    if (data.containsKey('breakHours')) {
      // New field
      try {
        breakHours = Map<String, List<String>>.from(data['breakHours']);
      } catch (e) {
        print('Error parsing breakHours: $e');
      }
    }

    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      category: category,
      rating: data['rating'] ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      experience: data['experience'] ?? 0,
      workingHours: workingHours,
      breakHours: breakHours, // New field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'category': category.id, // store the ID of the category
      'rating': rating,
      'reviewCount': reviewCount,
      'experience': experience,
      'workingHours': workingHours,
      'breakHours': breakHours, // New field
    };
  }
}
