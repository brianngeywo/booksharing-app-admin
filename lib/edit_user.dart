import 'package:admin_app/services/user_service.dart';
import 'package:flutter/material.dart';

import 'models/user_model.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;

  EditUserPage({super.key, required this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
    phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    addressController = TextEditingController(text: widget.user.address);
    bioController = TextEditingController(text: widget.user.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveChanges() {
    // Update user data with the changes
    widget.user.name = nameController.text;
    widget.user.email = emailController.text;
    widget.user.phoneNumber = phoneNumberController.text;
    widget.user.address = addressController.text;
    widget.user.bio = bioController.text;
    UserModel user = UserModel(
      id: widget.user.id,
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      address: addressController.text,
      bio: bioController.text,
      password: widget.user.password,
      profilePictureUrl: widget.user.profilePictureUrl,
      coverImageUrl: widget.user.coverImageUrl,
      approved: widget.user.approved,
    );
    // TODO: Save the updated user data to the database
    _uploadUser(user);

    // Show a success message or navigate to a different screen
  }

  _uploadUser(UserModel user) {
    UserService().updateUserInFirestore(user.id, user.toMap());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User updated successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
