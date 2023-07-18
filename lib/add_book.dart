import 'package:admin_app/services/book_service.dart';
import 'package:admin_app/services/user_service.dart';
import 'package:admin_app/test_data.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'models/book.dart';
import 'models/genre.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _coverUrlController = TextEditingController();
  TextEditingController _fileUrlController = TextEditingController();
  Genre? _selectedGenre;
  List<DropdownMenuItem<Genre>> _genreDropdownItems = [];

  // Other necessary variables and methods can be added here
  @override
  void initState() {
    super.initState();
    _genreDropdownItems = genres.map((Genre genre) {
      return DropdownMenuItem<Genre>(
        value: genre,
        child: Text(genre.name),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Create Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _coverUrlController,
              decoration: const InputDecoration(labelText: 'Cover URL'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _fileUrlController,
              decoration: const InputDecoration(labelText: 'File URL'),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<Genre>(
              value: _selectedGenre,
              items: _genreDropdownItems,
              onChanged: (Genre? selectedGenre) {
                setState(() {
                  _selectedGenre = selectedGenre;
                });
              },
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Genre? selectedGenre = _selectedGenre;
                String title = _titleController.text;
                String author = _authorController.text;
                String description = _descriptionController.text;
                String coverUrl = _coverUrlController.text ?? "";
                String fileUrl = _fileUrlController.text ?? "";

                if (selectedGenre != null) {
                  BookModel newBook = BookModel(
                    id: const Uuid()
                        .v4(), // Provide a unique ID for the new book
                    title: title,
                    author: author,
                    genre: selectedGenre!, // Replace with your genre object
                    description: description,
                    postedBy: UserService()
                        .getCurrentUserFromFirestore(), // Replace with the user who posted the book
                    coverUrl: coverUrl,
                    allowedUsers: [],
                    fileUrl: fileUrl,
                    approved: false, // Change as needed
                  );

                  // Perform any necessary operations with the new book object
                  BookService().addBook(newBook);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Book updated successfully!"),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Handle the case when no genre is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a genre!"),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
