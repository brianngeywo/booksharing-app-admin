import 'package:admin_app/admin.dart';
import 'package:admin_app/constants.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  "Book Sharing App",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Do what you love",
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    } else if (!value.contains("@")) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!.trim();
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your password";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!.trim();
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(textColor),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      // Perform login operation using _email and _password
                      var user = AuthService().loginUser(_email, _password);
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminPage(),
                          ),
                        );
                      } else {
                        const SnackBar(
                          content: Text(
                            "Login failed!",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent,
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
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
