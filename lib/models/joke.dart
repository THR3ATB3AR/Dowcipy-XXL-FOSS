class Joke {
  final int id;
  final String content;
  final int categoryId;
  final bool isFavorite;

  Joke({
    required this.id,
    required this.content,
    required this.categoryId,
    required this.isFavorite,
  });

  factory Joke.fromMap(Map<String, dynamic> map) {
    return Joke(
      id: map['_id'] as int,
      content: map['content'] as String,
      categoryId: map['categoryID'] as int,
      isFavorite: (map['favourite'] as int) == 1,
    );
  }
}
