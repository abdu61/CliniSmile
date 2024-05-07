import 'package:dental_clinic/services/auth.dart';
import 'package:dental_clinic/shared/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _RegisterState();
}

class _RegisterState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', phone = '', password = '', error = '';
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25.0, 80.0, 25.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Sign Up to CliniSmile',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
                const Text('Create an Account',
                    style: TextStyle(fontSize: 15.0)),
                const SizedBox(height: 30.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildTextField(
                          'Name',
                          (val) => val!.isEmpty ? 'Enter a name' : null,
                          (val) => name = val),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          'Email', _validateEmail, (val) => email = val),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                          'Phone',
                          (val) => val!.length != 8
                              ? 'Enter a valid phone number'
                              : null,
                          (val) => phone = val),
                      const SizedBox(height: 16.0),
                      _buildTextField('Password', _validatePassword,
                          (val) => password = val,
                          obscureText: !showPassword),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        style: buttonAuthenticateStyle.copyWith(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 126, 156, 252))),
                        onPressed: _register,
                        child: const Text('Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12.0),
                      Text(error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0)),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14.0),
                    children: <TextSpan>[
                      const TextSpan(text: "Already have an account? "),
                      TextSpan(
                        text: 'Sign In',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 77, 119, 255),
                            fontSize: 14.0),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => widget.toggleView(),
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

  TextFormField _buildTextField(String hint,
      String? Function(String?)? validator, Function(String) onChanged,
      {bool obscureText = false}) {
    return TextFormField(
      validator: validator,
      onChanged: (val) => setState(() => onChanged(val)),
      decoration: textInputDecoration.copyWith(hintText: hint),
      obscureText: obscureText,
    );
  }

  String? _validateEmail(String? val) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return !regex.hasMatch(val!) ? 'Enter a valid email' : null;
  }

  String? _validatePassword(String? val) {
    if (val != null && val.length < 8) return 'Password must be 8+ characters.';
    if (val != null && !val.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (val != null && !val.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (val != null && !val.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (val != null && !val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      dynamic result = await _auth.registerWithEmailAndPassword(
          name, email, phone, password);
      if (result == null) {
        setState(() => error = 'Oops! Please enter valid information');
      }
    }
  }
}
