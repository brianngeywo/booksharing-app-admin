import 'package:admin_app/models/user_model.dart';

class DiscussionPostComment {
  String id;
  UserModel author;
  String content;
  DateTime date;

  DiscussionPostComment({
    required this.id,
    required this.author,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author.toMap(),
      'content': content,
      'date': date.toString(),
    };
  }

  static DiscussionPostComment fromMap(Map<String, dynamic> map) {
    return DiscussionPostComment(
      id: map['id'],
      author: UserModel.fromMap(map['author']),
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }
}
