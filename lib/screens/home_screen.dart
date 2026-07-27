import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/categories_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/jokes_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      body: categoriesAsyncValue.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('Brak kategorii.'));
          }
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final progress = ref.watch(progressProvider)[category.id] ?? 0;
              final jokesAsync = ref.watch(
                jokesByCategoryProvider(category.id),
              );

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () {
                    context.push(
                      '/category/${category.id}',
                      extra: category.name,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        jokesAsync.when(
                          data: (jokes) {
                            if (jokes.isEmpty) return const SizedBox.shrink();
                            double progressValue = progress == 0
                                ? 0
                                : (progress + 1) / jokes.length;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(value: progressValue),
                                const SizedBox(height: 4),
                                Text('${progress + 1} / ${jokes.length}'),
                              ],
                            );
                          },
                          loading: () => const LinearProgressIndicator(),
                          error: (err, stack) =>
                              const Text('Błąd pobierania postępu'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Błąd: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/favorites');
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
