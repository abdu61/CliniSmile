import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/navigation/admin_nav.dart';
import 'package:dental_clinic/navigation/guest_nav.dart';
import 'package:dental_clinic/navigation/staff_nav.dart';
import 'package:dental_clinic/screens/authenticate/authenticate.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/navigation/customer_nav.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    // Return Authenticate widget if user is null
    if (user == null) {
      return Authenticate();
    } else {
      final dbService = DatabaseService(uid: user.uid);

      // Use FutureBuilder to handle the asynchronous getUserRole function
      return FutureBuilder<String>(
        future: authService.getUserRole(user.uid),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); // Show a loading spinner while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error if any
          } else {
            // Navigate to respective page based on user role
            switch (snapshot.data) {
              case 'admin':
                return AdminNav();
              case 'staff':
                return StaffNav();
              case 'Customer':
                return SplashScreen(
                    nextScreen: CustomerNav(auth: authService, db: dbService));
              default: // 'guest' or any other role
                return SplashScreen(
                    nextScreen: GuestNav(auth: authService, db: dbService));
            }
          }
        },
      );
    }
  }
}

// I also need authenticate to use splashscreen as well. Just another headsup basically the authenticate page have login which serves Mobile and Desktop. i need to show only for Mobile