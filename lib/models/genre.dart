class Genre {
  String id;
  String name;
  String image_url;

  Genre({
    required this.id,
    required this.name,
    required this.image_url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': image_url,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'],
      name: map['name'],
      image_url: map['image_url'],
    );
  }
}
