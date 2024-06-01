import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/models/feed.dart';
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
  final Rx<int> appointmentSelectedIndex = 0.obs;
  final List<Widget> screens;
  final RxBool isLoading = false.obs;
  final Rx<Users?> user = Rx<Users?>(null); // Variable to store the user data
  final RxList<Appointment> appointments =
      <Appointment>[].obs; // List to store appointments
  final RxList<FeedItem> feedItems =
      <FeedItem>[].obs; // List to store feed items

  CustomerNavigationController({required this.auth, required this.db})
      : screens = [
          Home(auth: auth, db: db),
          AppointmentPage(),
          const Feed(),
          Chat(auth: auth, db: db),
          Profile(auth: auth, db: db),
        ];

  void setAppointmentSelectedIndex(int index) {
    appointmentSelectedIndex.value = index;
  }

  int getAppointmentSelectedIndex() {
    return appointmentSelectedIndex.value;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    preloadData();
    preloadAppointmentData();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> preloadData() async {
    isLoading.value = true;
    // Preload data for each screen
    await Future.wait([
      preloadAppointmentData(),
      preloadFeedData('All'), // Initial load with all categories
      preloadProfileData(), // Changed to public method
    ]);
    isLoading.value = false;
  }

  Future<void> preloadAppointmentData() async {
    try {
      final appointmentDocs =
          await db.getAppointmentsByUserid(auth.currentUser!.uid).first;
      final fetchedAppointments = appointmentDocs.docs
          .map((doc) => Appointment.fromFirestore(doc))
          .toList();
      appointments.value = fetchedAppointments;
      update();
    } catch (e) {
      // Handle errors if necessary
      print('Failed to load appointments: $e');
    }
  }

  Future<void> preloadFeedData(String category) async {
    try {
      final fetchedFeedItems = category == 'All'
          ? await db.getFeedItems()
          : await db.getFeedItemsByCategory(category);
      feedItems.value = fetchedFeedItems;
    } catch (e) {
      // Handle errors if necessary
      print('Failed to load feed items: $e');
    }
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
