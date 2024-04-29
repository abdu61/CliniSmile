import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/categories.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

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
    return snapshot.docs
        .map((doc) => Category(
              id: doc.id,
              name: doc['name'],
              icon: doc['icon'],
            ))
        .toList();
  }

  Future<void> addCategory(Category category) {
    return _categoriesCollection.add({
      'name': category.name,
      'icon': category.icon,
    });
  }
}
