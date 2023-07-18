import 'package:admin_app/app_bar.dart';
import 'package:admin_app/books_page.dart';
import 'package:admin_app/edit_user.dart';
import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/sidebar.dart';
import 'package:admin_app/test_data.dart';
import 'package:admin_app/users_page.dart';
import 'package:flutter/material.dart';

import 'add_book.dart';
import 'add_user.dart';
import 'edit_book.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String selectedModule = 'books';
  BookModel? selectedBook;
  UserModel? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Admin Dashboard',
      ),
      body: Row(
        children: [
          Sidebar(
            onModuleSelected: (String module) {
              setState(() {
                selectedModule = module;
              });
            },
          ),
          Expanded(
            flex: 4,
            child: Builder(
              builder: (BuildContext context) {
                switch (selectedModule) {
                  case 'books':
                    return BooksPage(
                      actions: bookActions,
                      onBookSelected: (BookModel book) {
                        setState(() {
                          selectedBook = book; // set the selected book
                        });
                      },
                      onModuleSelected: (String module) {
                        setState(() {
                          selectedModule = module;
                        });
                      },
                    );
                  case 'users':
                    return UsersPage(
                      actions: userActions,
                      onUserSelected: (UserModel user) {
                        setState(() {
                          selectedUser = user; // set the selected user
                        });
                      },
                      onModuleSelected: (String module) {
                        setState(() {
                          selectedModule = module;
                        });
                      },
                    );
                  case 'addUser':
                    return AddUserScreen();
                  case 'addBook':
                    return AddBookPage();
                  case 'editBook':
                    return EditBookPage(book: selectedBook!);
                  case 'editUser':
                    return EditUserPage(user: selectedUser!);
                  default:
                    return UsersPage(
                      actions: userActions,
                      onUserSelected: (UserModel user) {
                        setState(() {
                          selectedUser = user; // set the selected user
                        });
                      },
                      onModuleSelected: (String module) {
                        setState(() {
                          selectedModule = module;
                        });
                      },
                    ); // Placeholder for an unmatched case
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
