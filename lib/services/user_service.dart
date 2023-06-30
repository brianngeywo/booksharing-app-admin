import 'package:admin_app/models/book.dart';
import 'package:admin_app/models/discussion_post_comment.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData);
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final QuerySnapshot querySnapshot =
        await _firestore.collection('users').get();

    final List<UserModel> users = [];
    querySnapshot.docs.forEach((documentSnapshot) {
      final userData = documentSnapshot.data() as Map<String, dynamic>;
      final user = UserModel.fromMap(userData);
      users.add(user);
    });

    return users;
  }

  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('users').doc(userId).update(updatedData);
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  // Borrow a book
  Future<void> borrowBook(String bookId) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final CollectionReference booksCollection =
            _firestore.collection('books');
        final DocumentReference bookDocRef = booksCollection.doc(bookId);

        // Check if the book exists
        final DocumentSnapshot bookSnapshot = await bookDocRef.get();
        if (bookSnapshot.exists) {
          // Update the borrower information
          await bookDocRef.collection('borrowers').doc(currentUser.uid).set({
            'borrowerId': currentUser.uid,
            'borrowedAt': DateTime.now(),
          });
          print('Book borrowed successfully!');
        } else {
          print('Book not found.');
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveComment(
      DiscussionPostComment comment, BookModel book) async {
    final commentData = {
      'comment': comment,
      'timestamp': DateTime.now(),
    };

    await FirebaseFirestore.instance
        .collection('books')
        .doc(book.id)
        .collection('comments')
        .add(commentData);
  }

  // get current user
  UserModel getCurrentUser() {
    UserModel user = UserModel(
      id: _firebaseAuth.currentUser!.uid,
      email: _firebaseAuth.currentUser!.email!,
      name: "",
      profilePictureUrl: "",
      address: '',
      password: '',
      phoneNumber: '',
      bio: '',
      coverImageUrl: '',
      approved: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      user = UserModel.fromMap(value.data() as Map<String, dynamic>);
    });
    return user;
  }
}
