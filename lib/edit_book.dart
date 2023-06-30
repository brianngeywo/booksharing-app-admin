import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/genre.dart';
import 'package:admin_app/services/book_service.dart';
import 'package:flutter/material.dart';

class EditBookPage extends StatefulWidget {
  final BookModel book;
  EditBookPage({Key? key, required this.book}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _author;
  late Genre _genre;
  late String _abstract;
  late String? _uploadedFileUrl;
  late String _coverImageUrl;
  late bool _approved;

  @override
  void initState() {
    super.initState();
    _genre = Genre.fromMap(widget.book.genre.toMap());
    _title = widget.book.title;
    _author = widget.book.author;
    _abstract = widget.book.description;
    _uploadedFileUrl = widget.book.fileUrl;
    _coverImageUrl = widget.book.coverUrl;
    _approved = widget.book.approved;
    print("_genre: ${_genre.name}");
  }

  Future<void> _uploadBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new Book object
      BookModel book = BookModel(
        id: widget.book.id,
        title: _title,
        author: _author,
        genre: _genre,
        postedBy: widget.book.postedBy,
        description: _abstract,
        coverUrl:
            _coverImageUrl.isEmpty ? widget.book.coverUrl : _coverImageUrl,
        allowedUsers: widget.book.allowedUsers,
        fileUrl: _uploadedFileUrl ?? widget.book.fileUrl,
        approved: _approved,
      );

      // Update the book in Firestore
      BookService().updateBook(book);

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _approved,
                        onChanged: (value) {
                          setState(() {
                            _approved = value!;
                          });
                        },
                      ),
                      const Text('Approved'),
                    ],
                  ),
                  TextFormField(
                    initialValue: _title,
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
                    initialValue: _author,
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
                  TextFormField(
                    initialValue: _abstract,
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
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: _uploadBook,
                    child: const Text(
                      'Update Book',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
