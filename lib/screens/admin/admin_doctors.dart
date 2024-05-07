import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/shared/loading.dart';

class ManageDoctors extends StatefulWidget {
  final AuthService authService;
  final DatabaseService databaseService;

  const ManageDoctors({
    Key? key,
    required this.authService,
    required this.databaseService,
  }) : super(key: key);

  @override
  _ManageDoctorsState createState() => _ManageDoctorsState();
}

class _ManageDoctorsState extends State<ManageDoctors> {
  late Future<List<Doctor>> _doctorDocs;
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String phoneNo = '';
  String bio = '';
  String profileImageUrl = '';
  int experience = 0;
  String categoryId = 'CogReMEKrPdbrJHUkSkX';

  @override
  void initState() {
    super.initState();
    _doctorDocs = widget.databaseService.getDoctors();
  }

  void _showAddDoctorDialog() {
    List<String> workingHours = List.filled(7, '');
    List<String> breakHours = List.filled(7, '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Doctor'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        onChanged: (val) => setState(() => name = val),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a name' : null,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) => setState(() => email = val),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) => setState(() => phoneNo = val),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a phone number' : null,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) => setState(() => bio = val),
                        validator: (val) => val!.isEmpty ? 'Enter a bio' : null,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) =>
                            setState(() => profileImageUrl = val),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a profile image URL' : null,
                        decoration: const InputDecoration(
                          labelText: 'Profile Image URL',
                        ),
                      ),
                      TextFormField(
                        onChanged: (val) =>
                            setState(() => experience = int.parse(val)),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter experience' : null,
                        decoration: const InputDecoration(
                          labelText: 'Experience',
                        ),
                        keyboardType: TextInputType
                            .number, // This will show a number keyboard
                      ),

                      // Working hours
                      for (var i = 0; i < 7; i++)
                        TextFormField(
                          onChanged: (val) =>
                              setState(() => workingHours[i] = val),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter working hours' : null,
                          decoration: InputDecoration(
                            labelText: 'Working hours for day ${i + 1}',
                          ),
                        ),

                      // Break hours
                      for (var i = 0; i < 7; i++)
                        TextFormField(
                          onChanged: (val) =>
                              setState(() => breakHours[i] = val),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter break hours' : null,
                          decoration: InputDecoration(
                            labelText: 'Break hours for day ${i + 1}',
                          ),
                        ),

                      // Category
                      FutureBuilder<List<Category>>(
                        future: widget.databaseService.getCategories(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Category>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          return DropdownButtonFormField<String>(
                            value: categoryId,
                            onChanged: (String? newValue) {
                              setState(() {
                                categoryId = newValue!;
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('Select a category'),
                              ),
                              ...snapshot.data!.map<DropdownMenuItem<String>>(
                                  (Category value) {
                                return DropdownMenuItem<String>(
                                  value: value.id,
                                  child: Text(value.name),
                                );
                              }).toList(),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
                      // Create a new Doctor object
                      Doctor newDoctor = Doctor(
                        id: "",
                        name: name,
                        bio: bio,
                        profileImageUrl: profileImageUrl,
                        category: Category(
                            id: categoryId,
                            name: '',
                            icon: ''), // Use the category ID
                        experience: experience,
                        workingHours: workingHours.asMap().map(
                            (key, value) => MapEntry(key.toString(), [value])),
                        breakHours: breakHours.asMap().map(
                            (key, value) => MapEntry(key.toString(), [value])),
                      );

                      // Add doctor to database
                      await widget.databaseService.addDoctor(newDoctor);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Doctor added')),
                      );
                    }
                  },
                ),
              ],
            );
          },
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
                  'Manage Doctors',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddDoctorDialog,
                  child: const Text('Add Doctor'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Doctor>>(
                future: _doctorDocs,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Doctor>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Loading());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = snapshot.data![index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(
                              'Doctor Name: ${doc.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('Category: ${doc.category.name}',
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
                                          'Are you sure you want to delete this doctor?'),
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
                                                    content:
                                                        Text('Doctor deleted')),
                                              );
                                              // Refresh the list view
                                              setState(() {
                                                _doctorDocs = widget
                                                    .databaseService
                                                    .getDoctors();
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
