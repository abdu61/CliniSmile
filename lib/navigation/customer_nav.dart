import 'package:dental_clinic/screens/customer/appointment.dart';
import 'package:dental_clinic/screens/customer/chat.dart';
import 'package:dental_clinic/screens/customer/feed.dart';
import 'package:dental_clinic/screens/customer/home.dart';
import 'package:dental_clinic/screens/customer/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerNav extends StatelessWidget {
  const CustomerNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This controller manages the state of your navigation.
    final controller = Get.put(CustomerNavigationController());
    final pageController = PageController();

    // The bottom navigation bar.
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0.0,
          selectedIndex: controller.selectedIndex.value,
          // Callback when a navigation item is selected.
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
            pageController.jumpToPage(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_calendar_outlined),
              label: 'Appointment',
            ),
            NavigationDestination(
              icon: Icon(Icons.feed_outlined),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.white,
          indicatorColor: const Color.fromARGB(255, 152, 176, 255),
        ),
      ),
      body: PageView(
        controller: pageController,
        children: controller.screens,
        onPageChanged: (index) {
          controller.selectedIndex.value = index;
        },
      ),
    );
  }
}

class CustomerNavigationController extends GetxController
    with WidgetsBindingObserver {
  // The currently selected index.
  final Rx<int> selectedIndex = 0.obs;

  // The screens for each navigation item.
  final screens = [
    Home(),
    AppointmentPage(),
    Feed(),
    Chat(),
    Profile(),
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.resumed) {
    //   selectedIndex.value = 0;
    // }
  }
}
