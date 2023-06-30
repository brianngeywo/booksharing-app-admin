import 'package:admin_app/constants.dart';
import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/genre.dart';
import 'package:admin_app/services/book_service.dart';
import 'package:admin_app/services/user_service.dart';
import 'package:admin_app/test_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _author;
  late Genre _genre;
  late String _abstract;

  @override
  void initState() {
    super.initState();
    _genre = genres[0];
    _title = "";
    _author = "";
    _abstract = "";
  }

  Future<void> _uploadBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new Book object
      BookModel book = BookModel(
        id: Uuid().v4(),
        title: _title,
        author: _author,
        genre: _genre,
        postedBy: UserService().getCurrentUser(),
        description: _abstract,
        coverUrl: "",
        allowedUsers: [],
        fileUrl: "",
        approved: false,
      );

      // Update the book in Firestore
      BookService().addBook(book);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Book updated successfully!"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload a Book',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Author'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _author = value!;
                  },
                ),
                DropdownButtonFormField<Genre>(
                  decoration: const InputDecoration(labelText: 'Genre'),
                  value: _genre,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a genre';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _genre = value!;
                    });
                  },
                  items: genres.map((genre) {
                    return DropdownMenuItem<Genre>(
                      value: genre,
                      child: Text(genre.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  minLines: 15,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Abstract',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a book abstract';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _abstract = value!;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(textColor),
                  ),
                  onPressed: _uploadBook,
                  child: const Text(
                    'Upload Book',
                    style: TextStyle(color: Colors.black54),
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
