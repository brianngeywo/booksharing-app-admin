import 'dart:io';
import 'package:admin_app/constants.dart';
import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/genre.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/services/book_service.dart';
import 'package:admin_app/services/firebase_storage_service.dart';
import 'package:admin_app/test_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

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
  late String? _fileUrl;
  late String? _uploadedfileUrl;
  late String _coverImageUrl;
  late bool _approved;

  @override
  void initState() {
    super.initState();
    _genre = Genre.fromMap(widget.book.genre.toMap());
    _title = widget.book.title;
    _author = widget.book.author;
    _abstract = widget.book.description;
    _uploadedfileUrl = widget.book.fileUrl;
    _coverImageUrl = widget.book.coverUrl;
    _approved = widget.book.approved;
    _fileUrl = "";
    print("_genre: ${_genre.name}");
  }

  Future<void> _pickBookFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'], // Add more extensions if needed
    );

    if (result != null) {
      setState(() {
        _fileUrl = result.files.single.path;
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      try {
        final imageUrl = await FirebaseStorageService.uploadToStorage(file);
        setState(() {
          _coverImageUrl = imageUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to upload book cover"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
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
        coverUrl: _coverImageUrl,
        allowedUsers: widget.book.allowedUsers,
        fileUrl: _uploadedfileUrl ?? widget.book.fileUrl,
        approved: widget.book.approved,
      );

      // Upload the book file to Firebase Storage
      if (_fileUrl != null) {
        File file = File(_fileUrl!);
        try {
          String fileUrl = await FirebaseStorageService.uploadToStorage(file);
          _uploadedfileUrl = fileUrl;
        } catch (e) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text(""),
          //     duration: Duration(seconds: 3),
          //   ),
          // );
          print(e.toString());
        }
      }

      // Add the book to Firestore
      BookService().updateBook(book);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Book uploaded successfully!"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                // DropdownButtonFormField<Genre>(
                //   decoration: const InputDecoration(labelText: 'Genre'),
                //   value: _genre,
                //   onChanged: (value) {
                //     setState(() {
                //       _genre = value!;
                //     });
                //   },
                //   items: genres.map((g) {
                //     return DropdownMenuItem<Genre>(
                //       value: g,
                //       child: Text(g.name),
                //     );
                //   }).toList(),
                // ),
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
                  onPressed: _pickCoverImage,
                  child: const Text(
                    'Upload Book Cover',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                if (_coverImageUrl != null && _coverImageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(
                      _coverImageUrl,
                      height: 200,
                    ),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickBookFile,
                  child: const Text(
                    'Attach Book File',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                if (_fileUrl != null && _fileUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Attached File: $_fileUrl',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
    );
  }
}
