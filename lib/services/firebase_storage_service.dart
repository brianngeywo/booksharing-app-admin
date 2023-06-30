import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String> uploadBytesToStorage(
      List<int> bytes, String filePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(filePath);
      final uploadTask = storageRef.putData(Uint8List.fromList(bytes));

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw e;
    }
  }

  static Future<String> uploadToStorage(File file) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('book_covers')
        .child('${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageReference.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    if (snapshot.state == TaskState.success) {
      final downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    }
    throw Exception('Image upload failed');
  }
}
