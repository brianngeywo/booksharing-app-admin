import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<String> uploadImageToStorage(File imageFile, String path) async {
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});
    if (snapshot.state == TaskState.success) {
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    throw Exception('Image upload failed');
  }

  static Future<String> uploadToStorage(File file) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('book_covers')
        .child('${DateTime.now().millisecondsSinceEpoch}');

    final uploadTask = storageRef.putFile(file);

    await uploadTask.whenComplete(() => null);

    return storageRef.getDownloadURL();
  }
}
