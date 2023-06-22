import 'package:admin_app/models/user_model.dart';

class ForumQuestionComment {
  final String id;
  final String comment;
  final UserModel postedBy;

  ForumQuestionComment({
    required this.id,
    required this.comment,
    required this.postedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'postedBy': postedBy.toMap(),
    };
  }

  static ForumQuestionComment fromMap(Map<String, dynamic> map) {
    return ForumQuestionComment(
      id: map['id'],
      comment: map['comment'],
      postedBy: UserModel.fromMap(map['postedBy']),
    );
  }
}
