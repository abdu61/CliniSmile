import 'package:dental_clinic/screens/admin/admin_expenses.dart';
import 'package:dental_clinic/screens/admin/admin_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminNav extends StatelessWidget {
  const AdminNav({super.key});

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
              icon: Icon(Icons.moving_rounded),
              label: 'Expenses',
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
    AdminHome(),
    Expenses(),
  ];
}
