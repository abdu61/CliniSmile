import 'package:dental_clinic/screens/authenticate/sign_in.dart';
import 'package:dental_clinic/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? SignIn(toggleView: toggleView)
        : SignUp(toggleView: toggleView);
  }

  void toggleView() => setState(() => showSignIn = !showSignIn);
}
