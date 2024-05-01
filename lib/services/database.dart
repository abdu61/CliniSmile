import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/models/doctor.dart';

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
    return _doctorsCollection.add({
      'name': doctor.name,
      'bio': doctor.bio,
      'profileImageUrl': doctor.profileImageUrl,
      'category': doctor.category.id,
      'rating': doctor.rating,
      'reviewCount': doctor.reviewCount,
      'experience': doctor.experience,
    });
  }

  Future<List<Doctor>> getDoctors() async {
    final snapshot = await _doctorsCollection.get();

    List<Future<Doctor>> doctorFutures = snapshot.docs.map((doc) async {
      try {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (!data.containsKey('name')) {
          throw Exception('Document ${doc.id} does not contain a "name" field');
        }

        Category category;
        try {
          category = await getCategoryById(data['category']);
        } catch (error) {
          category = Category(id: '0', name: 'No category', icon: '');
        }

        Doctor doctor = Doctor(
          id: doc.id,
          name: data['name'] ?? '',
          bio: data['bio'] ?? '',
          profileImageUrl: data['profileImageUrl'] ?? '',
          category: category,
          rating: data['rating'] ?? 0.0,
          reviewCount: data['reviewCount'] ?? 0,
          experience: data['experience'] ?? 0,
        );

        return doctor;
      } catch (error) {
        return Doctor(
          id: '',
          name: 'Error',
          bio: '',
          profileImageUrl: '',
          category: Category(id: '', name: 'error', icon: ''),
          rating: 0.0,
          reviewCount: 0,
          experience: 0,
        );
      }
    }).toList();

    List<Doctor> doctors = await Future.wait(doctorFutures);

    return doctors;
  }
}
