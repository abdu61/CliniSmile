import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/models/feed.dart';
import 'package:dental_clinic/models/appointment.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference _doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');
  final CollectionReference _feedItemsCollection =
      FirebaseFirestore.instance.collection('feedItems');
  final CollectionReference _appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  Future<void> updateUserData(
      String name, String email, String phone, String role) async {
    if (phone.length != 8) {
      throw Exception('Phone number must be 8 digits long');
    }

    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  Future<void> deleteUserData() async {
    return await userCollection.doc(uid).delete();
  }

  //Doctor Categories
  Future<List<Category>> getCategories() async {
    final snapshot = await _categoriesCollection.get();
    return snapshot.docs.map((doc) {
      return Category(
        id: doc.id,
        name: doc['name'],
        icon: doc['icon'],
      );
    }).toList();
  }

  Future<Category> getCategoryById(String id) async {
    final doc = await _categoriesCollection.doc(id).get();

    if (!doc.exists) {
      throw Exception('No category found with ID: $id');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? 'No name',
      icon: data['icon'] ?? '',
    );
  }

  Future<void> addCategory(Category category) {
    return _categoriesCollection.doc(category.id).set({
      'name': category.name,
      'icon': category.icon,
    });
  }

  // Doctors
  Future<void> addDoctor(Doctor doctor) {
    Map<String, String> workingHours = {};
    doctor.workingHours.forEach((key, value) {
      workingHours[key] = value.join('+'); // Convert List<String> to String
    });

    return _doctorsCollection.add({
      'name': doctor.name,
      'bio': doctor.bio,
      'profileImageUrl': doctor.profileImageUrl,
      'category': doctor.category.id,
      'rating': doctor.rating,
      'reviewCount': doctor.reviewCount,
      'experience': doctor.experience,
      'workingHours': workingHours, // New field
    });
  }

  Future<List<Doctor>> getDoctors() async {
    final snapshot = await _doctorsCollection.get();

    List<Future<Doctor>> doctorFutures = snapshot.docs.map((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      Category category = await getCategoryById(data['category']);

      Map<String, List<String>> workingHours = {};
      Map<String, dynamic>.from(data['workingHours'] ?? {})
          .forEach((key, value) {
        workingHours[key] =
            value.split('+'); // Convert String back to List<String>
      });

      return Doctor(
        id: doc.id,
        name: data['name'] ?? '',
        bio: data['bio'] ?? '',
        profileImageUrl: data['profileImageUrl'] ?? '',
        category: category,
        rating: data['rating'] ?? 0.0,
        reviewCount: data['reviewCount'] ?? 0,
        experience: data['experience'] ?? 0,
        workingHours: workingHours, // New field
      );
    }).toList();

    return await Future.wait(doctorFutures);
  }

// For displaying based on category
  Future<List<Doctor>> getDoctorsByCategory(String categoryId) async {
    final snapshot =
        await _doctorsCollection.where('category', isEqualTo: categoryId).get();

    List<Future<Doctor>> doctorFutures = snapshot.docs.map((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      Category category = await getCategoryById(data['category']);

      Map<String, List<String>> workingHours = {};
      Map<String, dynamic>.from(data['workingHours'] ?? {})
          .forEach((key, value) {
        workingHours[key] =
            value.split('+'); // Convert String back to List<String>
      });

      return Doctor(
        id: doc.id,
        name: data['name'] ?? '',
        bio: data['bio'] ?? '',
        profileImageUrl: data['profileImageUrl'] ?? '',
        category: category,
        rating: data['rating'] ?? 0.0,
        reviewCount: data['reviewCount'] ?? 0,
        experience: data['experience'] ?? 0,
        workingHours: workingHours, // New field
      );
    }).toList();

    return await Future.wait(doctorFutures);
  }

  // Feed Items
  // Method to create a new feed item
  Future<void> createFeedItem(FeedItem feedItem) {
    return _feedItemsCollection.add({
      'imageUrl': feedItem.imageUrl,
      'title': feedItem.title,
      'type': feedItem.type,
      'category': feedItem.category,
      if (feedItem.type == 'blog') 'content': feedItem.content,
    });
  }

  // Method to fetch all feed items
  Future<List<FeedItem>> getFeedItems() async {
    final snapshot = await _feedItemsCollection.get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return FeedItem(
        imageUrl: data['imageUrl'] ?? '',
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        type: data['type'] ?? '',
        category: data['category'] ?? '',
      );
    }).toList();
  }

// Method to fetch feed items by category
  Future<List<FeedItem>> getFeedItemsByCategory(String category) async {
    final snapshot =
        await _feedItemsCollection.where('category', isEqualTo: category).get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return FeedItem(
        imageUrl: data['imageUrl'] ?? '',
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        type: data['type'] ?? '',
        category: data['category'] ?? '',
      );
    }).toList();
  }

// Method to update a feed item
  Future<void> updateFeedItem(String id, FeedItem feedItem) {
    return _feedItemsCollection.doc(id).update({
      'imageUrl': feedItem.imageUrl,
      'title': feedItem.title,
      'type': feedItem.type,
      'category': feedItem.category,
      if (feedItem.type == 'blog') 'content': feedItem.content,
    });
  }

// Method to delete a feed item
  Future<void> deleteFeedItem(String id) {
    return _feedItemsCollection.doc(id).delete();
  }

  //Appointment
  Future<void> addAppointment(Appointment appointment, String formattedTime) {
    return _appointmentsCollection.add({
      'doctorId': appointment.doctorId,
      'userId': appointment.userId,
      'date': appointment.date,
      'time': formattedTime,
      'status': appointment.status,
      'paymentMethod': appointment.paymentMethod, // New field
    });
  }

  Future<List<Appointment>> getAppointmentsByUser(String userId) async {
    final snapshot =
        await _appointmentsCollection.where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Appointment(
        id: doc.id,
        doctorId: data['doctorId'] ?? '',
        userId: data['userId'] ?? '',
        date: (data['date'] as Timestamp)
            .toDate(), // Convert Timestamp to DateTime
        time: TimeOfDay.fromDateTime(DateTime.parse(
            '2022-01-01 ${data['time']}')), // Convert String to TimeOfDay
        status: data['status'] ?? 'pending',
        paymentMethod: data['paymentMethod'] ?? '', // New field
      );
    }).toList();
  }

  Future<void> updateAppointment(
      Appointment appointment, String formattedTime) {
    return _appointmentsCollection.doc(appointment.id).update({
      'doctorId': appointment.doctorId,
      'userId': appointment.userId,
      'date': appointment.date,
      'time': formattedTime,
      'status': appointment.status,
      'paymentMethod': appointment.paymentMethod, // New field
    });
  }

  Future<void> deleteAppointment(String id) {
    return _appointmentsCollection.doc(id).delete();
  }
}
