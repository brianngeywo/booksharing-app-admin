import 'package:admin_app/models/forum_question_comment.dart';
import 'package:admin_app/models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumService {
  final CollectionReference _forumCollection =
      FirebaseFirestore.instance.collection('forum_comments');

  Future<void> addForumQuestion(Question question) async {
    try {
      await _forumCollection.doc(question.id).set(question.toMap());
      print('Forum question added successfully!');
    } catch (e) {
      print('Failed to add forum question: $e');
    }
  }

  Future<List<Question>> fetchForumQuestions() async {
    try {
      final QuerySnapshot querySnapshot = await _forumCollection
          .orderBy('timeUploaded', descending: true)
          .get();
      final List<Question> questions = [];

      querySnapshot.docs.forEach((documentSnapshot) {
        final question =
            Question.fromMap(documentSnapshot.data() as Map<String, dynamic>);
        questions.add(question);
      });

      return questions;
    } catch (e) {
      print('Failed to fetch forum questions: $e');
      return [];
    }
  }

  Future<void> addForumComment(
      String questionId, ForumQuestionComment comment) async {
    try {
      await _forumCollection
          .doc(questionId)
          .collection('forumComments')
          .doc(comment.id)
          .set(comment.toMap());
      print('Forum comment added successfully!');
    } catch (e) {
      print('Failed to add forum comment: $e');
    }
  }

  Future<List<ForumQuestionComment>> fetchForumComments(
      String questionId) async {
    try {
      final QuerySnapshot querySnapshot = await _forumCollection
          .doc(questionId)
          .collection('forumComments')
          .get();
      final List<ForumQuestionComment> comments = [];

      querySnapshot.docs.forEach((documentSnapshot) {
        final data = documentSnapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          final comment = ForumQuestionComment.fromMap(data);
          comments.add(comment);
        }
      });

      return comments;
    } catch (e) {
      print('Failed to fetch forum comments: $e');
      return [];
    }
  }

// Other necessary operations can be added here
}
