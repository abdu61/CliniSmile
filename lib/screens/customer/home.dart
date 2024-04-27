import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading() // Show Loading widget when logging out
        : Scaffold(
            appBar: AppBar(
              title: const DefaultTextStyle(
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                child: Text('CliniSmile'),
              ),
              backgroundColor: Color(0xFF254EDB),
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  onPressed: () async {
                    //sign out
                    setState(() => loading = true);
                    await _auth.signOut();
                    if (mounted) {
                      setState(() => loading = false);
                    }
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'logout',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: const Center(
              child: Text('Home'),
            ),
          );
  }
}
