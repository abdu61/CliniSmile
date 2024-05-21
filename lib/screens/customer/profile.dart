import 'package:dental_clinic/navigation/customer_nav.dart';
import 'package:dental_clinic/screens/authenticate/authenticate.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/health_record.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/update_profile.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class Profile extends StatelessWidget {
  final AuthService auth;
  final DatabaseService db;

  const Profile({super.key, required this.auth, required this.db});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerNavigationController>();

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
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = controller.user.value;
        if (users == null) {
          return Center(child: Text('Error: Failed to load profile'));
        }

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
                trailing: const Icon(Icons.arrow_forward_ios, size: 18.0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            HealthRecordPage(userId: users.uid)),
                  );
                },
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
                trailing: const Icon(Icons.arrow_forward_ios, size: 18.0),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProfilePage(user: users),
                    ),
                  );
                  // Refresh profile data
                  await controller.preloadProfileData();
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
                  await auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Authenticate()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
