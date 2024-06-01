// ignore_for_file: prefer_const_constructors

import 'package:dental_clinic/keys.dart';
import 'package:dental_clinic/models/user.dart';
import 'package:dental_clinic/screens/wrapper.dart';
import 'package:dental_clinic/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Intialize API Keys - Make a keys.dart file in the lib folder and add the API keys
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: Keys.apiKey,
      appId: Keys.appId,
      messagingSenderId: Keys.messagingSenderId,
      projectId: Keys.projectId,
      storageBucket: Keys.storageBucket,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<Users?>.value(
          initialData: null, // Provide an initial value of type 'Users'
          value: AuthService().user,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CliniSmile',
        theme: ThemeData(
          primaryColor: const Color(0xFF254EDB),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(
                  255, 126, 156, 252), // Set the background color here
              padding: const EdgeInsets.all(5.0), // Add more padding here
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Set the border radius here
              ),
            ),
          ),
        ),
        home: Wrapper(),
      ),
    );
  }
}
