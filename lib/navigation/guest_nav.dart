import 'package:dental_clinic/screens/guest/guest_appointment.dart';
import 'package:dental_clinic/screens/guest/guest_feed.dart';
import 'package:dental_clinic/screens/guest/guest_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestNav extends StatelessWidget {
  const GuestNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the navigation controller
    final controller = Get.put(NavigationController());
    return Scaffold(
      // The bottom navigation bar is an Obx widget that reacts to changes in the controller's selectedIndex
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0.0,
          // The selected index is the current value of the controller's selectedIndex
          selectedIndex: controller.selectedIndex.value,
          // When a navigation item is selected, update the controller's selectedIndex
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          // Define the navigation destinations
          destinations: const [
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
          ],
          backgroundColor: Colors.white,
          indicatorColor: const Color.fromARGB(255, 152, 176, 255),
        ),
      ),
      // The body is an Obx widget that reacts to changes in the controller's selectedIndex
      // It displays the screen corresponding to the current selectedIndex
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

// Define a GetxController for the navigation
class NavigationController extends GetxController {
  // Define a reactive integer for the selected index
  final Rx<int> selectedIndex = 0.obs;

  // Define the screens for each navigation destination
  final screens = [
    GuestHome(),
    GuestAppointment(),
    GuestFeed(),
  ];
}
