import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';

class AdminExpenses extends StatelessWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const AdminExpenses(
      {Key? key, required this.authService, required this.databaseService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: const Center(
        child: Text('Expenses'),
      ),
    );
  }
}
