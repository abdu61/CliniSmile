import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const AdminHome(
      {Key? key, required this.authService, required this.databaseService})
      : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome Admin'),
      ),
    );
  }
}
