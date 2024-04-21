import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/screens/wrapper.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //add
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCADUjR8hCNuUpjghzaSUIXvC5nIBNGRlM',
      appId: '1:244068860490:android:2aaa61c53beea556319cb3',
      messagingSenderId: '244068860490',
      projectId: 'dental-app-ab452',
      storageBucket: 'dental-app-ab452.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
      initialData: null, // Provide an initial value of type 'Users'
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF254EDB), // Use hexadecimal color
        ),
        home: Wrapper(),
      ),
    );
  }
}
