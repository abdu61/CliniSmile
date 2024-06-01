import 'dart:io';
import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class UpdateProfilePage extends StatefulWidget {
  final Users user;

  UpdateProfilePage({required this.user});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String profile = '';
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    name = widget.user.name;
    phone = widget.user.phone;
    profile = widget.user.profile;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        // Check if the widget is still in the widget tree
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
        ),
      );
    }
  }

  Future<void> _uploadImageAndUpdateProfile() async {
    if (_imageFile != null) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profiles/${Path.basename(_imageFile!.path)}');
        await ref.putFile(File(_imageFile!.path));
        profile = await ref.getDownloadURL();

        // Show a SnackBar to notify the user that the image upload was successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded successfully'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
          ),
        );
        return;
      }
    }

    if (_formKey.currentState!.validate()) {
      try {
        await DatabaseService(uid: widget.user.uid).updateUserData(
            name, widget.user.email, phone, widget.user.role, profile);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Update Profile'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                if (profile.isNotEmpty)
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 0, 0, 0), // Set border color
                        width: 1.0, // Set border width
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(profile),
                      ),
                    ),
                  )
                else
                  const Text('No profile picture'),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 180.0, // Set the width
                      height: 50.0, // Set the height
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text(
                          'Pick Profile Picture',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: name,
                  onChanged: (val) => setState(() => name = val),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: phone,
                  onChanged: (val) => setState(() => phone = val),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                  ),
                  validator: (val) => val!.length != 8
                      ? 'Please enter a 8 digit phone number'
                      : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _uploadImageAndUpdateProfile,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 66.0),
                    child: Text('Update',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 66.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
