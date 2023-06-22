class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  String address;
  String password;
  String bio;
  String profilePictureUrl;
  String coverImageUrl;
  bool approved;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.password,
    required this.phoneNumber,
    required this.bio,
    required this.profilePictureUrl,
    required this.coverImageUrl,
    required this.approved,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'password': password,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'coverImageUrl': coverImageUrl,
      'approved': approved,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      password: map['password'],
      bio: map['bio'],
      profilePictureUrl: map['profilePictureUrl'],
      coverImageUrl: map['coverImageUrl'],
      approved: map['approved'],
    );
  }
}
