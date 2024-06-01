import 'package:dental_clinic/screens/staff/staff_appointment.dart';
import 'package:dental_clinic/screens/staff/staff_chat_list_ui.dart';
import 'package:dental_clinic/screens/staff/staff_home.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffNav extends StatefulWidget {
  @override
  _StaffNavState createState() => _StaffNavState();
}

class _StaffNavState extends State<StaffNav> {
  final AuthService auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService? db;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      db = DatabaseService(uid: user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StaffNavigationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Home',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25.0)),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              setState(() => loading = true);
              await auth.signOut();
              if (mounted) {
                setState(() => loading = false);
              }
            },
            icon: const Icon(Icons.logout_outlined,
                color: Color.fromARGB(255, 0, 0, 0)),
            label: const Text('logout',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold)),
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
                        icon: Icon(Icons.home_outlined, size: 30.0),
                        label: Text('Home',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500))),
                    NavigationRailDestination(
                        icon: Icon(Icons.calendar_today_outlined, size: 26.0),
                        label: Text('Appointment',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500))),
                    NavigationRailDestination(
                        icon: Icon(Icons.chat_outlined, size: 26.0),
                        label: Text('Chat',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500))),
                  ],
                )),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: db == null
                ? CircularProgressIndicator()
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
    (AuthService auth, DatabaseService db) =>
        StaffHome(authService: auth, databaseService: db),
    (AuthService auth, DatabaseService db) =>
        StaffAppointment(authService: auth, databaseService: db),
    (AuthService auth, DatabaseService db) => StaffChatListUI(),
  ];
}
