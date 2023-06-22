import 'package:admin_app/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference _booksRef;

  BookService() {
    _booksRef = _db.collection('books');
  }

  Future<List<BookModel>> getBooks() async {
    QuerySnapshot querySnapshot = await _booksRef.get();
    return querySnapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<BookModel> getBookById(String id) async {
    DocumentSnapshot doc = await _booksRef.doc(id).get();
    return BookModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<List<BookModel>> getBooksByUserId(String userId) async {
    QuerySnapshot querySnapshot = await _booksRef
        .where('postedBy.id', isEqualTo: userId)
        .get(); // Modify the query to match the user ID
    List<BookModel> books = querySnapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return books;
  }

  Future<List<BookModel>> getBooksByGenre(String genreId) async {
    QuerySnapshot querySnapshot =
        await _booksRef.where('genre.id', isEqualTo: genreId).get();
    List<BookModel> books = querySnapshot.docs
        .map((doc) => BookModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    return books;
  }

  Future<void> addBook(BookModel book) async {
    await _booksRef.add(book.toMap());
  }

  Future<void> updateBook(BookModel book) async {
    await _booksRef.doc(book.id).update(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await _booksRef.doc(id).delete();
  }

  //update upproval status using book id and approved boolean field
  Future<void> updateApprovalStatus(String id, bool approved) async {
    await _booksRef.doc(id).update({'approved': approved});
  }
}
