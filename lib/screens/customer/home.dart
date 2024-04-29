import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/cards/AppointmentPreviewCard.dart';
import 'package:dental_clinic/shared/widgets/category_circle.dart';
import 'package:dental_clinic/shared/widgets/section_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool loading = false;
  late Future<String> userName;

  @override
  void initState() {
    super.initState();
    userName = getUserName();
  }

  Future<String> getUserName() async {
    final User? user = _firebaseAuth.currentUser;
    final DatabaseService db = DatabaseService(uid: user?.uid ?? '');
    final DocumentSnapshot docSnapshot = await db.getUserData();
    return (docSnapshot.data() as Map<String, dynamic>)['name'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading() // Show Loading widget when logging out
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 70,
                title: FutureBuilder<String>(
                  future: userName,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else {
                      final hour = DateTime.now().hour;
                      String greeting;
                      if (hour < 12) {
                        greeting = 'Good morning';
                      } else if (hour < 17) {
                        greeting = 'Good afternoon';
                      } else {
                        greeting = 'Good evening';
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            greeting, // Greeting message
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 145, 145, 145),
                            ),
                          ),
                          Text(
                            '${snapshot.data}', // User's name
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'May your smile be ever bright!', // Dental quote
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFc42d5e),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                // Notification icon
                actions: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1), // Set your desired color and width
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the notification page
                        Navigator.pushNamed(context, '/notification');
                      },
                      child: const Icon(Icons.notifications_none_outlined,
                          size: 28),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                // Search bar
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(2.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(189, 189, 189, 1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: Color(0xFF254EDB)),
                        ),
                        hintText: 'Search for doctors...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 152, 176, 255),
                        ),
                        // Filter icon
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(6.0),
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 194, 194, 194),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: Column(
                  children: [
                    _MyAppointment(),
                    const SizedBox(height: 10),
                    _DoctorCategory(),
                    const SizedBox(height: 10),
                    _TopDoctors(),
                  ],
                ),
              ),
            ),
          );
  }
}

// Appointment Preview Cards
class _MyAppointment extends StatelessWidget {
  const _MyAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SectionTitle(
        title: 'My Appointments',
        action: 'View all',
        onPressed: () {},
      ),
      AppointmentPreviewCard(),
    ]);
  }
}

// Doctor Category - Shows upto 4 Categories
class _DoctorCategory extends StatelessWidget {
  const _DoctorCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService(uid: 'your_uid_here');
    return FutureBuilder<List<Category>>(
      future: databaseService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: [
              SectionTitle(
                title: 'Categories',
                action: 'View all',
                onPressed: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data!.take(4).map((category) {
                  IconData iconData;
                  try {
                    iconData = IconData(int.parse(category.icon),
                        fontFamily: 'MaterialIcons');
                  } catch (e) {
                    iconData = Icons.error; // Default icon in case of error
                  }
                  return Expanded(
                    child: CategoryCircle(
                      icon: iconData,
                      label: category.name,
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}

// Top Doctors - Shows upto 5 Doctors
class _TopDoctors extends StatelessWidget {
  const _TopDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: 'Our Doctors',
          action: 'View all',
          onPressed: () {},
        ),
      ],
    );
  }
}
