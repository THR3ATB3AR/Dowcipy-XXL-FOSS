import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/joke.dart';
import '../services/database_helper.dart';

class FavoritesNotifier extends StateNotifier<AsyncValue<List<Joke>>> {
  FavoritesNotifier() : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await DatabaseHelper.instance.getFavoriteJokes();
      state = AsyncValue.data(favorites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleFavorite(Joke joke) async {
    final bool currentlyFavorite = state.value?.any((j) => j.id == joke.id) ?? joke.isFavorite;
    final newStatus = !currentlyFavorite;
    await DatabaseHelper.instance.toggleFavorite(joke.id, newStatus);
    loadFavorites();
  }

  Future<void> removeAllFavorites() async {
    await DatabaseHelper.instance.removeAllFavorites();
    loadFavorites();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Joke>>>((ref) {
  return FavoritesNotifier();
});
