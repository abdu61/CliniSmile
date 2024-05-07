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
  final CollectionReference _userCollection =
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

    return await _userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await _userCollection.doc(uid).get();
  }

  Future<DocumentSnapshot> getUserById(String id) async {
    return await _userCollection.doc(id).get();
  }

  Future<QuerySnapshot> getUsersByRole(String role) async {
    return await _userCollection.where('role', isEqualTo: role).get();
  }

  Future<void> deleteUserData() async {
    return await _userCollection.doc(uid).delete();
  }

  Future<void> deleteUserById(String id) async {
    return await _userCollection.doc(id).delete();
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
    Map<String, String> breakHours = {};

    doctor.workingHours.forEach((key, value) {
      workingHours[key] = value.join('+'); // Convert List<String> to String
    });

    doctor.breakHours.forEach((key, value) {
      breakHours[key] = value.join('+'); // Convert List<String> to String
    });

    return _doctorsCollection.add({
      'name': doctor.name,
      'bio': doctor.bio,
      'profileImageUrl': doctor.profileImageUrl,
      'category': doctor.category.id,
      'rating': doctor.rating,
      'reviewCount': doctor.reviewCount,
      'experience': doctor.experience,
      'workingHours': workingHours, // Existing field
      'breakHours': breakHours, // New field
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

      Map<String, List<String>> breakHours = {};
      Map<String, dynamic>.from(data['breakHours'] ?? {}).forEach((key, value) {
        breakHours[key] =
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
        workingHours: workingHours,
        breakHours: breakHours, // New field
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

      Map<String, List<String>> breakHours = {};
      Map<String, dynamic>.from(data['breakHours'] ?? {}).forEach((key, value) {
        breakHours[key] =
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
        workingHours: workingHours,
        breakHours: breakHours, // New field
      );
    }).toList();

    return await Future.wait(doctorFutures);
  }

  Future<Doctor> getDoctorById(String doctorId) async {
    final doc = await _doctorsCollection.doc(doctorId).get();

    if (!doc.exists) {
      throw Exception('Doctor not found');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    Category category = await getCategoryById(data['category']);

    Map<String, List<String>> workingHours = {};
    Map<String, dynamic>.from(data['workingHours'] ?? {}).forEach((key, value) {
      workingHours[key] =
          value.split('+'); // Convert String back to List<String>
    });

    Map<String, List<String>> breakHours = {};
    Map<String, dynamic>.from(data['breakHours'] ?? {}).forEach((key, value) {
      breakHours[key] = value.split('+'); // Convert String back to List<String>
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
      workingHours: workingHours,
      breakHours: breakHours, // New field
    );
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
  Future<void> addAppointment(Appointment appointment) {
    return _appointmentsCollection.add({
      'doctorId': appointment.doctorId,
      'userId': appointment.userId,
      'start': appointment.start,
      'end': appointment.end,
      'status': appointment.status,
      'paymentMethod': appointment.paymentMethod,
      'bookingTime': appointment.bookingTime,
      'consultationFee': appointment.consultationFee,
      'userMode': appointment.userMode,
      'name': appointment.name,
      'phoneNumber': appointment.phoneNumber,
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
        start: (data['start'] as Timestamp).toDate(),
        end: (data['end'] as Timestamp).toDate(),
        status: data['status'] ?? 'pending',
        paymentMethod: data['paymentMethod'] ?? '',
        bookingTime: (data['bookingTime'] as Timestamp).toDate(),
        consultationFee: (data['billedAmount'] as num?)?.toDouble() ?? 0.0,
        userMode: data['userMode'] ?? 'Online',
        name: data['name'],
        phoneNumber: data['phoneNumber'],
      );
    }).toList();
  }

  Future<void> updateAppointment(Appointment appointment) {
    return _appointmentsCollection.doc(appointment.id).update({
      'doctorId': appointment.doctorId,
      'userId': appointment.userId,
      'start': appointment.start,
      'end': appointment.end,
      'status': appointment.status,
      'paymentMethod': appointment.paymentMethod,
      'bookingTime': appointment.bookingTime,
      'consultationFee': appointment.consultationFee,
      'userMode': appointment.userMode,
      'name': appointment.name,
      'phoneNumber': appointment.phoneNumber,
    });
  }

  Future<List<Appointment>> getAppointmentsByDoctorAndDate(
      String doctorId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    final snapshot = await _appointmentsCollection
        .where('doctorId', isEqualTo: doctorId)
        .where('start', isGreaterThanOrEqualTo: startOfDay)
        .where('start', isLessThanOrEqualTo: endOfDay)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Appointment(
        id: doc.id,
        doctorId: data['doctorId'] ?? '',
        userId: data['userId'] ?? '',
        start: (data['start'] as Timestamp).toDate(),
        end: (data['end'] as Timestamp).toDate(),
        status: data['status'] ?? 'pending',
        paymentMethod: data['paymentMethod'] ?? '',
        bookingTime: (data['bookingTime'] as Timestamp).toDate(),
        consultationFee: (data['billedAmount'] as num?)?.toDouble() ?? 0.0,
        userMode: data['userMode'] ?? 'Online',
        name: data['name'],
        phoneNumber: data['phoneNumber'],
      );
    }).toList();
  }

  Future<void> deleteAppointmentById(String id) {
    return _appointmentsCollection.doc(id).delete();
  }

  Future<void> deleteAppointment(Appointment appointment) {
    return _appointmentsCollection.doc(appointment.id).delete();
  }

  Stream<QuerySnapshot> getAppointmentsByUserid(String userId) {
    return _appointmentsCollection
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<List<Appointment>> getAllAppointments() async {
    final snapshot = await _appointmentsCollection.get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Appointment(
        id: doc.id,
        doctorId: data['doctorId'] ?? '',
        userId: data['userId'] ?? '',
        start: (data['start'] as Timestamp).toDate(),
        end: (data['end'] as Timestamp).toDate(),
        status: data['status'] ?? 'pending',
        paymentMethod: data['paymentMethod'] ?? '',
        bookingTime: (data['bookingTime'] as Timestamp).toDate(),
        consultationFee: (data['billedAmount'] as num?)?.toDouble() ?? 0.0,
        userMode: data['userMode'] ?? 'Online',
        name: data['name'],
        phoneNumber: data['phoneNumber'],
      );
    }).toList();
  }

  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    final snapshot = await _appointmentsCollection
        .where('start', isGreaterThanOrEqualTo: startOfDay)
        .where('start', isLessThanOrEqualTo: endOfDay)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return Appointment(
        id: doc.id,
        doctorId: data['doctorId'] ?? '',
        userId: data['userId'] ?? '',
        start: (data['start'] as Timestamp).toDate(),
        end: (data['end'] as Timestamp).toDate(),
        status: data['status'] ?? 'pending',
        paymentMethod: data['paymentMethod'] ?? '',
        bookingTime: (data['bookingTime'] as Timestamp).toDate(),
        consultationFee: (data['billedAmount'] as num?)?.toDouble() ?? 0.0,
        userMode: data['userMode'] ?? 'Online',
        name: data['name'],
        phoneNumber: data['phoneNumber'],
      );
    }).toList();
  }
}
