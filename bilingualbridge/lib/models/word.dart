class Word {
  final int id;
  final String english;
  final String turkish;
  final String image;

  Word({
    required this.id,
    required this.english,
    required this.turkish,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'english': english,
      'turkish': turkish,
      'image': image,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      english: map['english'],
      turkish: map['turkish'],
      image: map['image'],
    );
  }
}
