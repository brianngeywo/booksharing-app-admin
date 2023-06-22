import 'dart:io';

import 'package:admin_app/constants.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditUserScreen extends StatefulWidget {
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _email = "";
  String _password = "";
  String _phoneNumber = "";
  File? _coverImage;
  File? _profileImage;

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _coverImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _profileImage = File(pickedImage.path);
      }
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final coverImageUrl = await FirebaseStorageService()
            .uploadImageToStorage(_coverImage!,
                'cover_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final profileImageUrl = await FirebaseStorageService()
            .uploadImageToStorage(_profileImage!,
                'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        AuthService().signUpUser(
          _name,
          _email,
          _password,
          coverImageUrl,
          profileImageUrl,
          _phoneNumber,
        );
      } catch (e) {
        print('Error uploading images: $e');
        // Handle error
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100.0),
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!.trim();
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phoneNumber = value!.trim();
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!.trim();
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!.trim();
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _pickCoverImage,
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .white, // Set the button background color to transparent
                    ),
                    child: Text(
                      'Pick Cover Image',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: textColor, // Set the text color to blue
                      ),
                    ),
                  ),
                ),
                if (_coverImage != null) ...[
                  const SizedBox(height: 16.0),
                  Image.file(
                    _coverImage!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _pickProfileImage,
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .white, // Set the button background color to transparent
                    ),
                    child: Text(
                      'Pick Profile Image',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: textColor, // Set the text color to blue
                      ),
                    ),
                  ),
                ),
                if (_profileImage != null) ...[
                  const SizedBox(height: 16.0),
                  Image.file(
                    _profileImage!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
                const SizedBox(height: 32.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      primary:
                          textColor, // Set the button background color to transparent
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
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
