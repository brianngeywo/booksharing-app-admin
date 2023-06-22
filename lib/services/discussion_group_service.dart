import 'package:admin_app/models/discussion_post.dart';
import 'package:admin_app/models/discussion_post_comment.dart';
import 'package:admin_app/models/genre.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionGroupService {
  final CollectionReference _postsCollection =
      FirebaseFirestore.instance.collection('discussion_posts');

  Future<List<DiscussionPost>> fetchDiscussionPosts() async {
    try {
      final QuerySnapshot querySnapshot = await _postsCollection.get();
      final List<DiscussionPost> posts = [];

      querySnapshot.docs.forEach((documentSnapshot) {
        final post = DiscussionPost.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
        posts.add(post);
      });

      return posts;
    } catch (e) {
      print('Failed to fetch discussion posts: $e');
      return [];
    }
  }

  Future<void> addDiscussionPost(DiscussionPost post) async {
    try {
      await _postsCollection.doc(post.id).set(post.toMap());
    } catch (e) {
      print('Failed to add discussion post: $e');
    }
  }

  Future<void> addComment(
      String discussionPostId, DiscussionPostComment comment) async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('discussion_posts')
          .doc(discussionPostId);

      await postRef.update({
        'comments': FieldValue.arrayUnion([comment.toMap()]),
      });
    } catch (e) {
      print('Failed to add comment: $e');
      rethrow;
    }
  }

  Future<List<DiscussionPost>> fetchDiscussionPostsByGenre(Genre genre) async {
    try {
      final QuerySnapshot querySnapshot =
          await _postsCollection.where('genre.id', isEqualTo: genre.id).get();
      final List<DiscussionPost> posts = [];

      querySnapshot.docs.forEach((documentSnapshot) {
        final post = DiscussionPost.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
        posts.add(post);
      });

      return posts;
    } catch (e) {
      print('Failed to fetch discussion posts: $e');
      return [];
    }
  }

  Future<List<DiscussionPostComment>> fetchComments(
      String discussionPostId) async {
    try {
      final postRef = _postsCollection.doc(discussionPostId);

      final documentSnapshot = await postRef.get();
      final postMap = documentSnapshot.data() as Map<String, dynamic>;

      final List<DiscussionPostComment> comments = [];

      if (postMap.containsKey('comments')) {
        final commentsList = postMap['comments'] as List<dynamic>;
        commentsList.forEach((commentMap) {
          final comment = DiscussionPostComment.fromMap(commentMap);
          comments.add(comment);
        });
      }

      return comments;
    } catch (e) {
      print('Failed to fetch comments: $e');
      return [];
    }
  }
}
