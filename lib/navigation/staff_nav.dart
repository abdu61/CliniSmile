import 'package:dental_clinic/screens/staff/staff_appointment.dart';
import 'package:dental_clinic/screens/staff/staff_chat.dart';
import 'package:dental_clinic/screens/staff/staff_home.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffNav extends StatefulWidget {
  StaffNav({Key? key}) : super(key: key);

  @override
  State<StaffNav> createState() => _StaffNavState();
}

class _StaffNavState extends State<StaffNav> {
  final AuthService auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService? db;
  bool loading = false;
  late Future<String> userName;
  String? userId;

  @override
  void initState() {
    super.initState();

    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      db = DatabaseService(uid: user.uid);
    }

    userName = getUserName();
    userId = _firebaseAuth.currentUser?.uid;
  }

  Future<String> getUserName() async {
    final User? user = _firebaseAuth.currentUser;
    final DocumentSnapshot docSnapshot = await db!.getUserData();
    return (docSnapshot.data() as Map<String, dynamic>)['name'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    final controller = Get.put(StaffNavigationController());
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Staff Home'),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              //sign out
              setState(() => loading = true);
              await auth.signOut();
              if (mounted) {
                setState(() => loading = false);
              }
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            label: const Text(
              'logout',
              style: TextStyle(
                fontSize: 16.0,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            height: double.infinity,
            color: const Color.fromARGB(255, 220, 227, 255),
            alignment: Alignment.bottomCenter,
            child: Obx(() => NavigationRail(
                  backgroundColor: Colors.transparent,
                  indicatorColor: const Color.fromARGB(255, 255, 255, 255),
                  selectedIndex: controller.selectedIndex.value,
                  onDestinationSelected: (int index) {
                    controller.selectedIndex.value = index;
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.home_outlined,
                        size: 30.0,
                      ),
                      label: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_today_outlined, size: 26.0),
                      label: Text(
                        'Appointment',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chat_outlined, size: 26.0), // Chat icon
                      label: Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: db == null
                ? CircularProgressIndicator() // Loading indicator
                : Obx(() => controller.screens[controller.selectedIndex.value](
                    auth, db!)),
          ),
        ],
      ),
    );
  }
}

class StaffNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    (auth, db) => StaffHome(authService: auth, databaseService: db),
    (auth, db) => StaffAppointment(authService: auth, databaseService: db),
    (auth, db) => StaffChat(authService: auth, databaseService: db),
  ];
}
