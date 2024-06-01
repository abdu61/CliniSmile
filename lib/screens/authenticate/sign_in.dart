import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/shared/constant.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';
  bool loading = false;
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 80.0, 25.0, 0.0),
                child: kIsWeb
                    ? Center(
                        child: Container(
                          width: width * 0.5,
                          child: SingleChildScrollView(
                            child: buildColumn(context, width),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: buildColumn(context, width),
                      ),
              ),
            ),
          );
  }

  Widget buildColumn(BuildContext context, double width) {
    return Column(
      children: [
        buildWelcomeText(),
        const SizedBox(height: 30.0),
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildEmailField(width),
                const SizedBox(height: 20.0),
                buildPasswordField(width),
                const SizedBox(height: 20.0),
                buildSignInButton(width),
                const SizedBox(height: 6.0),
                buildErrorText(),
                const SizedBox(height: 15.0),
                if (!kIsWeb) buildGuestSignInButton(),
                const SizedBox(height: 20.0),
                if (!kIsWeb) buildSignUpLink(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWelcomeText() {
    return const Text(
      'Welcome Back',
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildEmailField(double width) {
    return SizedBox(
      width: kIsWeb ? width * 0.3 : width,
      child: TextFormField(
        controller: emailController,
        validator: (val) => validateEmail(val),
        decoration: textInputDecoration.copyWith(hintText: 'Email'),
      ),
    );
  }

  Widget buildPasswordField(double width) {
    return SizedBox(
      width: kIsWeb ? width * 0.3 : width,
      child: TextFormField(
        controller: passwordController,
        obscureText: !showPassword,
        validator: (val) => validatePassword(val),
        decoration: textInputDecoration.copyWith(
          hintText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
              color: const Color.fromARGB(255, 126, 156, 252),
            ),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
        ),
      ),
    );
  }

  Widget buildSignInButton(double width) {
    return SizedBox(
      width: kIsWeb ? width * 0.3 : width,
      child: ElevatedButton(
        style: buttonAuthenticateStyle.copyWith(
          backgroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 126, 156, 252),
          ),
        ),
        onPressed: () async => await signIn(),
        child: const Text(
          'Sign in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildErrorText() {
    return Text(
      error,
      style: TextStyle(color: Colors.red[800], fontSize: 12.0),
    );
  }

  Widget buildGuestSignInButton() {
    return ElevatedButton(
      style: buttonAuthenticateStyle.copyWith(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(6),
      ),
      child: const Text(
        'Guest',
        style: TextStyle(
          color: Color.fromARGB(255, 77, 119, 255),
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () async => await signInAsGuest(),
    );
  }

  Widget buildSignUpLink() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        children: <TextSpan>[
          const TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: 'Sign Up Now',
            style: const TextStyle(
              color: Color.fromARGB(255, 77, 119, 255),
              fontSize: 14.0,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                widget.toggleView();
              },
          ),
        ],
      ),
    );
  }

  String? validateEmail(String? val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(val!)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? val) {
    return val != null && val.isEmpty ? 'Please enter your password.' : null;
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      dynamic result = await _auth.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (result == null) {
        if (mounted) {
          setState(() {
            error = 'Sign-in failed. Check your credentials & try again';
            loading = false;
          });
        }
      }
    }
  }

  Future<void> signInAsGuest() async {
    setState(() => loading = true);
    String? result = await _auth.signInAnon();
    if (result == null) {
      print('error signing in');
      if (mounted) {
        setState(() => loading = false);
      }
    } else {
      print('signed in');
      print(result);
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }
}
