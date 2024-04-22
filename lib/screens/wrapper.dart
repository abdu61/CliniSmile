import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/screens/admin/admin_home.dart';
import 'package:dental_clinic/screens/authenticate/authenticate.dart';
import 'package:dental_clinic/screens/guest/guest_home.dart';
import 'package:dental_clinic/screens/home/home.dart';
import 'package:dental_clinic/screens/staff/staff_home.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/shared/loading.dart';
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
      // Use FutureBuilder to handle the asynchronous getUserRole function
      return FutureBuilder<String>(
        future: authService.getUserRole(user.uid),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(); // Show a loading spinner while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error if any
          } else {
            // Navigate to respective page based on user role
            switch (snapshot.data) {
              case 'admin':
                return AdminHome();
              case 'staff':
                return StaffHome();
              case 'guest':
                return GuestHome();
              default: // 'customer' or any other role
                return Home();
            }
          }
        },
      );
    }
  }
}
