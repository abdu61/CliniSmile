import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
}
