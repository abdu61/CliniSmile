import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String role;
  final String profile;

  Users({
    required this.uid,
    this.email = '',
    this.name = '',
    this.phone = '',
    this.role = '',
    this.profile = '',
  });

  // Add a factory method to create a Users from a DocumentSnapshot
  factory Users.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Users(
      uid: doc.id,
      email: doc['email'] as String? ?? '',
      name: doc['name'] as String? ?? '',
      phone: doc['phone'] as String? ?? '',
      role: doc['role'] as String? ?? '',
      profile: doc['profile'] as String? ??
          'https://firebasestorage.googleapis.com/v0/b/dental-app-ab452.appspot.com/o/defaultProfile.jpg?alt=media&token=27941f06-4878-4d2c-a5ca-5477bc506fa8',
    );
  }

  // Add a factory method to create a Users from a Firebase User
  factory Users.fromFirebaseUser(User user) {
    return Users(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      // You need to replace 'defaultRole' and 'defaultProfile' with the actual default role and profile
      role: 'defaultRole',
      profile:
          'https://firebasestorage.googleapis.com/v0/b/dental-app-ab452.appspot.com/o/defaultProfile.jpg?alt=media&token=27941f06-4878-4d2c-a5ca-5477bc506fa8',
    );
  }

  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
      uid: doc.id,
      name: doc['name'],
      email: doc['email'],
      phone: doc['phone'],
      role: doc['role'],
      profile: (doc.data() as Map<String, dynamic>?)?.containsKey('profile') ??
              false
          ? doc['profile']
          : '', // cast doc.data() to Map<String, dynamic> before calling containsKey
    );
  }
}
