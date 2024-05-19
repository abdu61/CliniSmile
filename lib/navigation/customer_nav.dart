import 'package:dental_clinic/models/user.dart';
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return buildPageView(controller, pageController);
      }),
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
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(
          icon: Icon(Icons.edit_calendar_outlined), label: 'Appointment'),
      NavigationDestination(icon: Icon(Icons.feed_outlined), label: 'Feed'),
      NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Chat'),
      NavigationDestination(
          icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
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
  final RxBool isLoading = false.obs;
  final Rx<Users?> user =
      Rx<Users?>(null); // Add a variable to store the user data

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
    preloadData();
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

  Future<void> preloadData() async {
    isLoading.value = true;
    // Preload data for each screen
    await Future.wait([
      _preloadHomeData(),
      _preloadAppointmentData(),
      _preloadFeedData(),
      _preloadChatData(),
      preloadProfileData(),
    ]);
    isLoading.value = false;
  }

  Future<void> _preloadHomeData() async {
    // Add your data fetching logic here
  }

  Future<void> _preloadAppointmentData() async {
    // Add your data fetching logic here
  }

  Future<void> _preloadFeedData() async {
    // Add your data fetching logic here
  }

  Future<void> _preloadChatData() async {
    // Add your data fetching logic here
  }

  Future<void> preloadProfileData() async {
    try {
      user.value = await db.getUserDetails(); // Fetch and store user details
    } catch (e) {
      // Handle errors if necessary
      print('Failed to load user profile: $e');
    }
  }
}
