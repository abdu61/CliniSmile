import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;

  Users({required this.uid});

  // Add a factory method to create a Users from a DocumentSnapshot
  factory Users.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Users(
      uid: doc.id,
    );
  }
}
