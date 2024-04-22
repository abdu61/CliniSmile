import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/shared/constant.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  //Loading state
  bool loading = false;

  // Password visibility state
  bool showPassword = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            //AppBar

            //Body
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 80.0, 25.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 30.0, // Change the font size
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Login to your Account',
                        style: TextStyle(
                          fontSize: 15.0, // Change the font size
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            // Wrap form fields in a Column
                            children: <Widget>[
                              const SizedBox(height: 20.0),

                              //Email TextFormField
                              TextFormField(
                                controller: emailController,
                                validator: (val) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern.toString());
                                  if (!regex.hasMatch(val!)) {
                                    return 'Enter a valid email';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Email'),
                              ),
                              const SizedBox(height: 20.0),

                              //Password TextFormField
                              TextFormField(
                                controller: passwordController,
                                obscureText: !showPassword,
                                validator: (val) => val != null && val.isEmpty
                                    ? 'Please enter your password.'
                                    : null,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),

                              //Sign In Button
                              ElevatedButton(
                                style: buttonAuthenticateStyle,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text);
                                    if (result == null) {
                                      if (mounted) {
                                        setState(() {
                                          error =
                                              'Sign-in failed. Check your credentials & try again';
                                          loading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Text(
                                error,
                                style: TextStyle(
                                    color: Colors.red[800], fontSize: 12.0),
                              ),
                              const SizedBox(height: 15.0),

                              // Guest Sign In
                              ElevatedButton(
                                style: buttonAuthenticateStyle.copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  elevation: MaterialStateProperty.all(6),
                                ),
                                child: const Text(
                                  'Guest',
                                  style: TextStyle(color: Color(0xFF254EDB)),
                                ),
                                onPressed: () async {
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
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      //Sign Up Link
                      RichText(
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
                                color: Color(0xFF254EDB),
                                fontSize: 14.0,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
