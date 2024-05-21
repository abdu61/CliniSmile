import 'package:dental_clinic/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/services/auth.dart';

class GuestProfile extends StatefulWidget {
  const GuestProfile({super.key});

  @override
  State<GuestProfile> createState() => _GuestProfileState();
}

class _GuestProfileState extends State<GuestProfile> {
  final AuthService _auth = AuthService();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Profile'),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                //sign out
                setState(() => loading = true);
                await _auth.signOut();
                if (mounted) {
                  setState(() => loading = false);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 241, 241, 241)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color.fromARGB(255, 255, 112, 102),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
