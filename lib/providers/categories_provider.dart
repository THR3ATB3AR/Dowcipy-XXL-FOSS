import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/joke_category.dart';
import '../services/database_helper.dart';

final categoriesProvider = FutureProvider<List<JokeCategory>>((ref) async {
  return await DatabaseHelper.instance.getCategories();
});
