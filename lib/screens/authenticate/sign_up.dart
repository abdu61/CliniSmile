import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/shared/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  // ignore: prefer_const_constructors_in_immutables
  SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _RegisterState();
}

class _RegisterState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String email = '';
  String phone = '';
  String password = '';

  // Password visibility state
  bool showPassword = false;

  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Body
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25.0, 80.0, 25.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Sign Up to CliniSmile',
                  style: TextStyle(
                    fontSize: 30.0, // Change the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 15.0, // Change the font size
                  ),
                ),
                const SizedBox(height: 30.0),
                Form(
                  key: _formKey,
                  child: Column(
                    // Wrap form fields in a Column
                    children: <Widget>[
                      const SizedBox(height: 20.0),

                      //Name TextFormField
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a name' : null,
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Name'),
                      ),
                      const SizedBox(height: 20.0),

                      //Email TextFormField
                      TextFormField(
                        validator: (val) {
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = RegExp(pattern.toString());
                          if (!regex.hasMatch(val!)) {
                            return 'Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                      ),
                      const SizedBox(height: 20.0),

                      //Phone TextFormField
                      TextFormField(
                        validator: (val) => val!.length != 8
                            ? 'Enter a valid phone number'
                            : null,
                        onChanged: (val) {
                          setState(() => phone = val);
                        },
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Phone'),
                      ),
                      const SizedBox(height: 20.0),

                      //Password TextFormField
                      TextFormField(
                        obscureText: !showPassword,
                        validator: (val) {
                          if (val != null && val.length < 8) {
                            return 'Password must be 8+ characters.';
                          } else if (val != null &&
                              !val.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one number';
                          } else if (val != null &&
                              !val.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain at least one uppercase letter';
                          } else if (val != null &&
                              !val.contains(RegExp(r'[a-z]'))) {
                            return 'Password must contain at least one lowercase letter';
                          } else if (val != null &&
                              !val.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                            return 'Password must contain at least one special character';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                          helperText:
                              'Password must contain at least 8 characters,\none uppercase, one lowercase letter,\none no and one special character',
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 126, 156, 252),
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

                      //SignUp Button
                      ElevatedButton(
                        style: buttonAuthenticateStyle.copyWith(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 126, 156, 252))),
                        onPressed: () async {
                          //Registration
                          if (_formKey.currentState!.validate()) {
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    name, email, phone, password);
                            if (result == null) {
                              setState(() => error =
                                  'Oops! Please enter valid information');
                            }
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      //Error Text
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                //Sign In Button
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: 'Sign In',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
