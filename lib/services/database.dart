import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/models/doctor_package.dart';
import 'package:dental_clinic/models/doctor_working_hours.dart';

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
  final CollectionReference _doctorPackagesCollection =
      FirebaseFirestore.instance.collection('doctorPackages');
  final CollectionReference _doctorWorkingHoursCollection =
      FirebaseFirestore.instance.collection('doctorWorkingHours');

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

  // Doctors
  Future<void> addDoctor(Doctor doctor) {
    return _doctorsCollection.add({
      'name': doctor.name,
      'bio': doctor.bio,
      'profileImageUrl': doctor.profileImageUrl,
      'categoryId': doctor.categoryId,
      'packageIds': doctor.packageIds,
      'workingHourIds': doctor.workingHourIds,
      'rating': doctor.rating,
      'reviewCount': doctor.reviewCount,
      'patientCount': doctor.patientCount,
    });
  }

  Future<List<Doctor>> getDoctors() async {
    final snapshot = await _doctorsCollection.get();
    return snapshot.docs
        .map((doc) => Doctor(
              id: doc.id,
              name: doc['name'],
              bio: doc['bio'],
              profileImageUrl: doc['profileImageUrl'],
              categoryId: doc['categoryId'],
              packageIds: List<String>.from(doc['packageIds']),
              workingHourIds: List<String>.from(doc['workingHourIds']),
              rating: doc['rating'],
              reviewCount: doc['reviewCount'],
              patientCount: doc['patientCount'],
            ))
        .toList();
  }

  Future<void> addDoctorPackage(DoctorPackage doctorPackage) {
    return _doctorPackagesCollection.add({
      'doctorId': doctorPackage.doctorId,
      'packageName': doctorPackage.packageName,
      'description': doctorPackage.description,
      'duration': doctorPackage.duration,
      'price': doctorPackage.price,
      'consultationMode': doctorPackage.consultationMode,
    });
  }

  Future<List<DoctorPackage>> getDoctorPackages(String doctorId) async {
    final snapshot = await _doctorPackagesCollection
        .where('doctorId', isEqualTo: doctorId)
        .get();
    return snapshot.docs
        .map((doc) => DoctorPackage(
              id: doc.id,
              doctorId: doc['doctorId'],
              packageName: doc['packageName'],
              description: doc['description'],
              duration: doc['duration'],
              price: doc['price'],
              consultationMode: doc['consultationMode'],
            ))
        .toList();
  }

  Future<void> addDoctorWorkingHours(DoctorWorkingHours doctorWorkingHours) {
    return _doctorWorkingHoursCollection.add({
      'doctorId': doctorWorkingHours.doctorId,
      'startTime': doctorWorkingHours.startTime,
      'endTime': doctorWorkingHours.endTime,
      'dayOfWeek': doctorWorkingHours.dayOfWeek,
    });
  }

  Future<List<DoctorWorkingHours>> getDoctorWorkingHours(
      String doctorId) async {
    final snapshot = await _doctorWorkingHoursCollection
        .where('doctorId', isEqualTo: doctorId)
        .get();
    return snapshot.docs
        .map((doc) => DoctorWorkingHours(
              id: doc.id,
              doctorId: doc['doctorId'],
              startTime: (doc['startTime'] as Timestamp).toDate(),
              endTime: (doc['endTime'] as Timestamp).toDate(),
              dayOfWeek: doc['dayOfWeek'],
            ))
        .toList();
  }
}
