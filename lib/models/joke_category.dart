class JokeCategory {
  final int id;
  final String name;

  JokeCategory({required this.id, required this.name});

  factory JokeCategory.fromMap(Map<String, dynamic> map) {
    return JokeCategory(
      id: map['_id'] as int,
      name: map['name'] as String,
    );
  }
}
