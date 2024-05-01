import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/Lists/doctor_list_tile.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  CategoryPage({required this.categoryName, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final database = DatabaseService(uid: 'your_uid_here');
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color.fromARGB(255, 152, 176, 255),
      ),
      body: FutureBuilder<List<Doctor>>(
        future: database.getDoctorsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return DoctorListTile(doctor: snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
