import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';

class StaffChat extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const StaffChat({
    Key? key,
    required this.authService,
    required this.databaseService,
  }) : super(key: key);

  @override
  State<StaffChat> createState() => _StaffChatState();
}

class _StaffChatState extends State<StaffChat> {
  @override
  Widget build(BuildContext context) {
    // You can now use widget.authService and widget.databaseService here
    return const Placeholder();
  }
}
