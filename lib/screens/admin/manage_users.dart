import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsers extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const ManageUsers(
      {Key? key, required this.authService, required this.databaseService})
      : super(key: key);

  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  late Future<QuerySnapshot> _userDocs;

  @override
  void initState() {
    super.initState();
    _userDocs = widget.databaseService.getUsersByRole('Customer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Users',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: _userDocs,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = snapshot.data!.docs[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(
                              'Customer Name: ${doc['name']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Customer Email: ${doc['email']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 24),
                              onPressed: () {
                                widget.databaseService.deleteUserById(doc.id);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
