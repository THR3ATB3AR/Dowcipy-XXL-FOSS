import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';

final totalJokesProvider = FutureProvider<int>((ref) async {
  return await DatabaseHelper.instance.getTotalJokesCount();
});
