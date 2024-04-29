import 'package:dental_clinic/screens/staff/staff_appointment.dart';
import 'package:dental_clinic/screens/staff/staff_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffNav extends StatelessWidget {
  const StaffNav({super.key});

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
          ],
          backgroundColor: Colors.white,
          indicatorColor: const Color.fromARGB(255, 152, 176, 255),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    StaffHome(),
    StaffAppointment(),
  ];
}
