import 'package:admin_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UsersRightSidebar extends StatefulWidget {
  final UserModel user;

  const UsersRightSidebar({required this.user});

  @override
  _UsersRightSidebarState createState() => _UsersRightSidebarState();
}

class _UsersRightSidebarState extends State<UsersRightSidebar> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  // Add more text editing controllers for other user fields if needed

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          // Add more text form fields for other user fields if needed
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Save updated user details
              String newName = nameController.text;
              String newEmail = emailController.text;
              // Update the user object with new values

              // Call a function to save the updated user details
              saveUpdatedUserDetails(newName, newEmail);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void saveUpdatedUserDetails(String newName, String newEmail) {
    // Perform the necessary logic to save the updated user details
    // You can make an API call, update the database, or perform any other required operations
  }
}
