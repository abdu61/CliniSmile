import 'package:dental_clinic/screens/customer/appointment.dart';
import 'package:dental_clinic/screens/customer/chat.dart';
import 'package:dental_clinic/screens/customer/feed.dart';
import 'package:dental_clinic/screens/customer/home.dart';
import 'package:dental_clinic/screens/customer/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerNav extends StatelessWidget {
  const CustomerNav({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0.0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today),
              label: 'Appointment',
            ),
            NavigationDestination(
              icon: Icon(Icons.feed),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.white,
          indicatorColor: Color.fromARGB(255, 113, 146, 255),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    Home(),
    Appointment(),
    Feed(),
    Chat(),
    Profile(),
  ];
}
