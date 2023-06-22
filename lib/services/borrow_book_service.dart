import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowBookService {
  CollectionReference<Map<String, dynamic>> bookCollection =
      FirebaseFirestore.instance.collection('books');
  List<UserModel> users = [];

  Future<void> fetchAllUsers() async {
    users = await UserService().getAllUsers();
  }

  Future<void> borrowBook(String bookId, String userId) async {
    await fetchAllUsers();

    DocumentSnapshot<Map<String, dynamic>> bookSnapshot =
        await bookCollection.doc(bookId).get();
    BookModel? book = BookModel.fromMap(bookSnapshot.data()!);

    UserModel? user = users.firstWhere((user) => user.id == userId!);

    if (book != null && user != null) {
      if (!book.allowedUsers.contains(user)) {
        book.allowedUsers.add(user);
        await bookCollection.doc(bookId).set(book.toMap());
        print('Book ${book.title} borrowed by user ${user.name}');
      } else {
        print('Book ${book.title} is already borrowed by user ${user.name}');
      }
    } else {
      print('Book or user not found.');
    }
  }

  Future<void> printBookStatus(String bookId) async {
    DocumentSnapshot<Map<String, dynamic>> bookSnapshot =
        await bookCollection.doc(bookId).get();
    BookModel? book = BookModel.fromMap(bookSnapshot.data()!);

    if (book != null) {
      print('Book ${book.title} status:');
      if (book.allowedUsers.isNotEmpty) {
        print('Borrowed by:');
        for (var user in book.allowedUsers) {
          print('- ${user.name}');
        }
      } else {
        print('Available for borrowing.');
      }
    } else {
      print('Book not found.');
    }
  }
}
