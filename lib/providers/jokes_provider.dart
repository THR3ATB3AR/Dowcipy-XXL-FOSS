import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/joke.dart';
import '../services/database_helper.dart';

final jokesByCategoryProvider = FutureProvider.family<List<Joke>, int>((ref, categoryId) async {
  return await DatabaseHelper.instance.getJokesByCategory(categoryId);
});

final searchJokesProvider = FutureProvider.family<List<Joke>, String>((ref, query) async {
  return await DatabaseHelper.instance.searchJokes(query);
});
