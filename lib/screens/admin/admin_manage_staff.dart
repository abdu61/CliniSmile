import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStaff extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const ManageStaff(
      {Key? key, required this.authService, required this.databaseService})
      : super(key: key);

  @override
  _ManageStaffState createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  late Future<QuerySnapshot> _userDocs;
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phoneNo = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _userDocs = widget.databaseService.getUsersByRole('staff');
  }

  void _showAddStaffDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Staff'),
          content: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  onChanged: (val) => setState(() => name = val),
                  validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextFormField(
                  onChanged: (val) => setState(() => email = val),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  onChanged: (val) => setState(() => phoneNo = val),
                  validator: (val) =>
                      val!.isEmpty ? 'Enter a phone number' : null,
                  decoration: const InputDecoration(
                    labelText: 'Phone No',
                  ),
                ),
                TextFormField(
                  onChanged: (val) => setState(() => password = val),
                  validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Add staff to database
                  String result = await widget.authService
                      .registerStaff(name, email, phoneNo, password);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Manage Staff',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddStaffDialog,
                  child: const Text('Add Staff'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: _userDocs,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Loading());
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
                              'Staff Name: ${doc['name']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Email: ${doc['email']}',
                                style: const TextStyle(fontSize: 16)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red, size: 24),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete this staff member?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Delete'),
                                          onPressed: () async {
                                            await widget.databaseService
                                                .deleteUserById(doc.id);
                                            if (mounted) {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Staff member deleted')),
                                              );
                                              // Refresh the list view
                                              setState(() {
                                                _userDocs = widget
                                                    .databaseService
                                                    .getUsersByRole('staff');
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
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
