import 'package:dental_clinic/screens/customer/appointment.dart';
import 'package:dental_clinic/screens/customer/chat.dart';
import 'package:dental_clinic/screens/customer/feed.dart';
import 'package:dental_clinic/screens/customer/home.dart';
import 'package:dental_clinic/screens/customer/profile.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerNav extends StatelessWidget {
  final AuthService auth;
  final DatabaseService db;

  const CustomerNav({super.key, required this.auth, required this.db});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CustomerNavigationController(auth: auth, db: db));
    final pageController = PageController();

    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(controller, pageController),
      body: buildPageView(controller, pageController),
    );
  }

  Widget buildBottomNavigationBar(
      CustomerNavigationController controller, PageController pageController) {
    return Obx(
      () => NavigationBar(
        height: 80,
        elevation: 0.0,
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (index) {
          controller.selectedIndex.value = index;
          pageController.jumpToPage(index);
        },
        destinations: buildNavigationDestinations(),
        backgroundColor: Colors.white,
        indicatorColor: const Color.fromARGB(255, 152, 176, 255),
      ),
    );
  }

  List<NavigationDestination> buildNavigationDestinations() {
    return const [
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
    ];
  }

  Widget buildPageView(
      CustomerNavigationController controller, PageController pageController) {
    return PageView(
      controller: pageController,
      children: controller.screens,
      onPageChanged: (index) {
        controller.selectedIndex.value = index;
      },
    );
  }
}

class CustomerNavigationController extends GetxController
    with WidgetsBindingObserver {
  final AuthService auth;
  final DatabaseService db;
  final Rx<int> selectedIndex = 0.obs;
  final List<Widget> screens;

  CustomerNavigationController({required this.auth, required this.db})
      : screens = [
          Home(auth: auth, db: db),
          AppointmentPage(auth: auth, db: db),
          Feed(),
          Chat(auth: auth, db: db),
          Profile(auth: auth, db: db),
        ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }
}
