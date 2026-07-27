import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import '../providers/favorites_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/stats_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final progressMap = ref.watch(progressProvider);
    final totalJokesAsync = ref.watch(totalJokesProvider);

    int totalFavorites = favoritesAsync.value?.length ?? 0;
    int totalRead = progressMap.values.fold(0, (sum, val) => sum + val);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statystyki',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  totalJokesAsync.when(
                    data: (total) => Text('Wszystkie dowcipy: $total'),
                    loading: () =>
                        const Text('Wszystkie dowcipy: ładowanie...'),
                    error: (_, __) => const Text('Wszystkie dowcipy: błąd'),
                  ),
                  const SizedBox(height: 8),
                  Text('Ulubione dowcipy: $totalFavorites'),
                  const SizedBox(height: 8),
                  Text('Przeczytane dowcipy: $totalRead (szacunkowo)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Motyw aplikacji',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      final currentThemeId =
                          DynamicTheme.of(context)?.themeId ?? 0;
                      final isDynamic = currentThemeId % 2 != 0;
                      final themeModeIndex = currentThemeId ~/ 2;

                      return Column(
                        children: [
                          DropdownButtonFormField<int>(
                            value: themeModeIndex,
                            decoration: const InputDecoration(
                              labelText: 'Tryb jasny / ciemny',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Systemowy'),
                              ),
                              DropdownMenuItem(value: 1, child: Text('Jasny')),
                              DropdownMenuItem(value: 2, child: Text('Ciemny')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                final newThemeId =
                                    (value * 2) + (isDynamic ? 1 : 0);
                                DynamicTheme.of(context)?.setTheme(newThemeId);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Kolory z tapety (Material You)'),
                            subtitle: const Text('Użyj systemowej palety barw'),
                            value: isDynamic,
                            onChanged: (value) {
                              final newThemeId =
                                  (themeModeIndex * 2) + (value ? 1 : 0);
                              DynamicTheme.of(context)?.setTheme(newThemeId);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zarządzanie',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Zresetować postęp?'),
                          content: const Text(
                            'Zaczniesz czytać wszystkie kategorie od początku.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Anuluj'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(progressProvider.notifier)
                                    .resetAllProgress();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Postęp został zresetowany'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Resetuj',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Zresetuj postęp'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Usunąć wszystkie ulubione?'),
                          content: const Text(
                            'Ta operacja jest nieodwracalna.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Anuluj'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(favoritesProvider.notifier)
                                    .removeAllFavorites();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ulubione zostały usunięte'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Usuń',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Usuń wszystkie ulubione'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
