import 'package:admin_app/books_page.dart';
import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/services/book_service.dart';
import 'package:admin_app/services/user_service.dart';
import 'package:admin_app/sidebar.dart';
import 'package:admin_app/test_data.dart';
import 'package:admin_app/users_page.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<UserModel> users = [];
  List<BookModel> books = [];
  String selectedModule = 'books';

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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: Sidebar(
        onModuleSelected: (String module) {
          setState(() {
            selectedModule = module;
          });
        },
      ),
      body: selectedModule == 'books'
          ? BooksPage(
              books: books,
              actions: bookActions,
            )
          : UsersPage(
              users: users,
              actions: userActions,
            ),
    );
  }
}
