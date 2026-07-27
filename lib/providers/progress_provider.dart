import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressNotifier extends StateNotifier<Map<int, int>> {
  ProgressNotifier() : super({}) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<int, int> progressMap = {};
    for (String key in keys) {
      if (key.startsWith('category_progress_')) {
        int categoryId = int.parse(key.replaceFirst('category_progress_', ''));
        progressMap[categoryId] = prefs.getInt(key) ?? 0;
      }
    }
    state = progressMap;
  }

  Future<void> saveProgress(int categoryId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('category_progress_$categoryId', index);
    state = {...state, categoryId: index};
  }

  int getProgress(int categoryId) {
    return state[categoryId] ?? 0;
  }
  Future<void> resetAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith('category_progress_')) {
        await prefs.remove(key);
      }
    }
    state = {};
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, Map<int, int>>((ref) {
  return ProgressNotifier();
});
