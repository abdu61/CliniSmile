import 'package:dental_clinic/screens/customer/feed.dart';
import 'package:dental_clinic/screens/customer/home.dart';
import 'package:dental_clinic/screens/guest/guest_profile.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestNav extends StatelessWidget {
  final AuthService auth;
  final DatabaseService db;

  const GuestNav({super.key, required this.auth, required this.db});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(auth: auth, db: db));

    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(controller),
      body: buildBody(controller),
    );
  }

  Widget buildBottomNavigationBar(NavigationController controller) {
    return Obx(
      () => NavigationBar(
        height: 80,
        elevation: 0.0,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (index) =>
            controller.selectedIndex.value = index,
        destinations: buildNavigationDestinations(),
        backgroundColor: Colors.white,
        indicatorColor: const Color.fromARGB(255, 152, 176, 255),
      ),
    );
  }

  List<NavigationDestination> buildNavigationDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.feed),
        label: 'Feed',
      ),
      NavigationDestination(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  Widget buildBody(NavigationController controller) {
    return Obx(() => controller.screens[controller.selectedIndex.value]);
  }
}

class NavigationController extends GetxController {
  final AuthService auth;
  final DatabaseService db;
  final Rx<int> selectedIndex = 0.obs;

  NavigationController({required this.auth, required this.db})
      : screens = [Home(auth: auth, db: db), Feed(), GuestProfile()];

  final List<Widget> screens;
}
