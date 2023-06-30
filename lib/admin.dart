import 'package:admin_app/app_bar.dart';
import 'package:admin_app/books_page.dart';
import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/services/book_service.dart';
import 'package:admin_app/services/user_service.dart';
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
  List<UserModel> users = [];
  List<BookModel> books = [];
  String selectedModule = 'books';
  BookModel? selectedBook;

  // create function to fetch users from fiebase using UserService().getAllUsers()
  void fetchAllUsers() async {
    users = await UserService().getAllUsers();
  }

  // create function to fetch books from fiebase using BookService().getAllBooks()
  void fetchAllBooks() async {
    books = await BookService().getBooks();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAllUsers();
    fetchAllBooks();
    super.initState();
  }

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
                      books: books,
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
                      users: users,
                      actions: userActions,
                    );
                  case 'addUser':
                    return AddUserScreen();
                  case 'addBook':
                    return const AddBookPage();
                  case 'editBook':
                    return EditBookPage(book: selectedBook!);
                  default:
                    return UsersPage(
                      users: users,
                      actions: userActions,
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
