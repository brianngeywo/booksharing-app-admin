import 'package:admin_app/models/action_model.dart';
import 'package:admin_app/models/book.dart';
import 'package:admin_app/services/book_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BooksPage extends StatefulWidget {
  final List<BookModel> books;
  final List<ActionModel> actions;
  final Function(BookModel) onBookSelected;
  final Function(String) onModuleSelected;

  BooksPage({
    required this.books,
    required this.actions,
    required this.onBookSelected,
    required this.onModuleSelected,
  });

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          var bk = widget.books[index];

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ListTile(
                  title: Text(
                    bk.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    bk.author,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    for (ActionModel action in widget.actions)
                      IconButton(
                          icon: Icon(action.icon),
                          onPressed: () {
                            switch (action.name) {
                              case "View":
                                setState(() {
                                  widget.onBookSelected(bk);
                                  widget.onModuleSelected('editBook');
                                });
                                break;
                              case "Delete":
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Delete ${bk.title}"),
                                      content: Text(
                                          "Are you sure you want to delete ${bk.title}?"),
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
                                            child: Text("Delete"),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection('books')
                                                  .doc(bk.id)
                                                  .delete();
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                break;
                              case "Update":
                                setState(() {
                                  widget.onBookSelected(bk);
                                  widget.onModuleSelected('editBook');
                                });
                                break;
                              case "Approve":
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Approve ${bk.title}"),
                                      content: Text(
                                          "Are you sure you want to approve ${bk.title}?"),
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
                                            BookService().updateApprovalStatus(
                                                bk.id, true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                break;
                            }
                          }),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: widget.books.length,
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
