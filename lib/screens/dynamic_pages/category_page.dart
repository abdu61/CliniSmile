import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/Lists/doctor_list_tile.dart';
import 'package:dental_clinic/shared/widgets/search_bar.dart';
import 'package:flutter/material.dart' hide SearchBar;

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  CategoryPage({required this.categoryName, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final database = DatabaseService(uid: 'your_uid_here');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: SearchBar(),
        ),
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
                  return DoctorListTile(
                      doctor: snapshot.data![index], userId: 'your_uid_here');
                },
              ),
            );
          }
        },
      ),
    );
  }
}
