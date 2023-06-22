import 'package:admin_app/models/genre.dart';
import 'package:admin_app/models/user_model.dart';

class BookModel {
  String id;
  String title;
  String author;
  Genre genre;
  String description;
  String coverUrl;
  UserModel postedBy;
  List<UserModel> allowedUsers;
  String? fileUrl;
  bool approved;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.postedBy,
    required this.coverUrl,
    required this.allowedUsers,
    required this.fileUrl,
    required this.approved,
  });
  BookModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        author = map['author'],
        genre = Genre.fromMap(map["genre"]),
        description = map['description'],
        coverUrl = map['coverUrl'],
        postedBy = UserModel.fromMap(map['postedBy']),
        allowedUsers = (map['allowedUsers'] as List<dynamic>)
            .map((user) => UserModel.fromMap(user))
            .toList(),
        fileUrl = map['fileUrl'],
        approved = map['approved'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre.toMap(),
        'description': description,
        'coverUrl': coverUrl,
        'postedBy': postedBy.toMap(),
        'allowedUsers': allowedUsers.map((user) => user.toMap()).toList(),
        'fileUrl': fileUrl,
        'approved': approved,
      };
}
