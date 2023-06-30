import 'package:admin_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUserInFirestore(
      String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData);
  }

  Future<Map<String, dynamic>?> getUserFromFirestore(String userId) async {
    final DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsersFromFirestore() async {
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

  Future<void> updateUserInFirestore(
      String userId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('users').doc(userId).update(updatedData);
  }

  Future<void> deleteUserFromFirestore(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  // get current user
  UserModel getCurrentUserFromFirestore() {
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

  //update upproval status using book id and approved boolean field
  Future<void> updateApprovalStatus(String id, bool approved) async {
    await _firestore.collection('users').doc(id).update({'approved': approved});
  }
}
