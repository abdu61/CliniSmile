import 'package:flutter/material.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';

class ManageCategory extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const ManageCategory({
    Key? key,
    required this.authService,
    required this.databaseService,
  }) : super(key: key);

  @override
  _ManageCategoryState createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Manage Category Page'),
      ),
    );
  }
}
