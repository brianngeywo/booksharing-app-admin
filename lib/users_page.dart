import 'package:admin_app/models/action_model.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/users_right_sidebar.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  final List<UserModel> users;
  final List<ActionModel> actions;

  UsersPage({
    required this.users,
    required this.actions,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  UserModel? my_user;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: GridView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          my_user = widget.users[index];

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ListTile(
                  title: Text(
                    my_user!.name,
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
                            if (action.name == 'View') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("${my_user!.name} Details"),
                                    content: UsersRightSidebar(user: my_user!),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {}
                          }),
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
      ),
    );
  }
}
