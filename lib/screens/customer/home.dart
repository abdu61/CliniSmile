import 'package:dental_clinic/models/categories.dart';
import 'package:dental_clinic/models/doctor.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/models/appointment.dart';
import 'package:dental_clinic/screens/customer/appointment.dart';
import 'package:dental_clinic/screens/customer/dynamic_pages/category_page.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/Lists/doctor_list_tile.dart';
import 'package:dental_clinic/shared/widgets/cards/appointment_preview_card.dart';
import 'package:dental_clinic/shared/widgets/category_circle.dart';
import 'package:dental_clinic/shared/widgets/section_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  final AuthService auth;
  final DatabaseService db;

  const Home({super.key, required this.auth, required this.db});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: db.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userRole = userData['role'];
          final userId = auth.currentUser?.uid;

          return Scaffold(
            appBar: MyAppBar(
              getUserName: () async {
                final docSnapshot = await db.getUserData();
                return (docSnapshot.data() as Map<String, dynamic>)['name'] ??
                    'User';
              },
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
              child: Column(
                children: [
                  if (userRole != 'guest') ...[
                    _MyAppointment(),
                  ],
                  const SizedBox(height: 10),
                  _DoctorCategory(),
                  const SizedBox(height: 10),
                  _Doctors(userId: userId, userRole: userRole),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Future<String> Function()
      getUserName; // Function to get user name asynchronously

  const MyAppBar({super.key, required this.getUserName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // Use FutureBuilder to handle asynchronous user name fetching
      future:
          getUserName(), // Call getUserName function to fetch user name asynchronously
      builder: (context, snapshot) {
        return AppBar(
          toolbarHeight: 60,
          title: snapshot.connectionState == ConnectionState.waiting
              ? const Loading() // Show loading indicator while fetching user name
              : _buildGreeting(context, snapshot.data!),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
              icon: const Icon(Icons.notifications_none_outlined, size: 28),
            ),
            const SizedBox(width: 12),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(2.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                        color: Color.fromRGBO(189, 189, 189, 1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFF254EDB)),
                  ),
                  hintText: 'Search for doctors...',
                  prefixIcon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 152, 176, 255)),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 194, 194, 194),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Icon(Icons.filter_list_outlined,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column _buildGreeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          greeting,
          style: const TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 145, 145, 145)),
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        const Text(
          'May your smile be ever bright!',
          style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Color(0xFFc42d5e)),
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 70.0);
}

//My Appointment
class _MyAppointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final dbService = DatabaseService(uid: userId!);

    return Column(children: [
      SectionTitle(
        title: 'My Appointments',
        action: 'View all',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentPage()),
          );
        },
      ),
      StreamBuilder<QuerySnapshot>(
        stream: dbService.getAppointmentsByUserid(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final appointments = snapshot.data!.docs
              .map((doc) => Appointment.fromFirestore(doc))
              .toList()
            ..sort((a, b) => a.start.compareTo(b.start));

          if (appointments.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 126, 156, 252),
                    Color.fromARGB(255, 168, 188, 255)
                  ],
                ),
              ),
              child: SizedBox(
                height: 90,
                child: Center(
                  child: Text(
                    'No appointment yet',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 170,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return AppointmentPreviewCard(appointment: appointments[index]);
              },
            ),
          );
        },
      ),
    ]);
  }
}

class _DoctorCategory extends StatelessWidget {
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
                  return Expanded(
                    child: CategoryCircle(
                      iconData:
                          getIcon(category.icon), // Pass the icon name here
                      label: category.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                              categoryName: category.name,
                              categoryId: category.id,
                            ),
                          ),
                        );
                      },
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

// Top Doctors
class _Doctors extends StatelessWidget {
  final String? userId;
  String? userRole;

  _Doctors({super.key, this.userId, this.userRole});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService(uid: 'your_uid_here');
    return FutureBuilder<List<Doctor>>(
      future: databaseService.getDoctors(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: [
              SectionTitle(
                title: 'Our Doctors',
                action: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryPage(
                        categoryName: 'All Doctors',
                        categoryId: '',
                        isAllDoctors: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4.0),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.hasData ? snapshot.data!.length : 0,
                itemBuilder: (context, index) {
                  return DoctorListTile(
                      doctor: snapshot.data![index],
                      userId: userId ?? '',
                      userRole: userRole ?? '');
                },
              ),
            ],
          );
        }
      },
    );
  }
}
