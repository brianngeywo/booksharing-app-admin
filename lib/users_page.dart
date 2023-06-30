import 'package:admin_app/models/action_model.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  final List<ActionModel> actions;
  final Function(UserModel) onUserSelected;
  final Function(String) onModuleSelected;

  UsersPage({
    required this.actions,
    required this.onUserSelected,
    required this.onModuleSelected,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: StreamBuilder<List<UserModel>>(
          stream: usersStream(),
          builder: (context, snapshot) {
            List<UserModel> users = snapshot.data ?? [];
            return GridView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel myUser = users[index];

                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          myUser!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (ActionModel action in widget.actions)
                            IconButton(
                              icon: Icon(action.icon),
                              onPressed: () {
                                switch (action.name) {
                                  case 'Approve':
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Approve ${myUser.name}"),
                                          content:
                                              Text("Are you sure you want to "
                                                  "approve ${myUser.name}?"),
                                          actions: [
                                            TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Approve"),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                UserService()
                                                    .updateApprovalStatus(
                                                        myUser.id, true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    break;
                                  case 'Delete':
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Delete User?'),
                                            content: Text(
                                                'Are you sure you want to delete ${myUser.name}?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(myUser.id)
                                                      .delete();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        });
                                    break;
                                  case 'View':
                                    setState(() {
                                      widget.onModuleSelected('editUser');
                                      widget.onUserSelected(myUser);
                                    });
                                    break;
                                  case 'Edit':
                                    setState(() {
                                      widget.onModuleSelected('editUser');
                                      widget.onUserSelected(myUser);
                                    });
                                    break;
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
            );
          }),
    );
  }

  Stream<List<UserModel>> usersStream() {
    return FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());
  }
}
