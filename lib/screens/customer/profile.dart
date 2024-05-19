import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/update_profile.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final AuthService auth;
  final DatabaseService db;

  Profile({Key? key, required this.auth, required this.db}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: FutureBuilder<Users>(
        future: widget.db.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Users users = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(users.profile),
                      ),
                      const SizedBox(height: 8.0),
                      Text(users.name,
                          style: const TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text(
                      'Health Records',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 4.0),
                Card(
                  child: ListTile(
                    title: const Text(
                      'Update Account Details',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfilePage(user: users),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 4.0),
                Card(
                  child: ListTile(
                    title: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 255, 112, 102),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      //sign out
                      setState(() => loading = true);
                      await widget.auth.signOut();
                      if (mounted) {
                        setState(() => loading = false);
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
