import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/jokes_provider.dart';
import '../providers/favorites_provider.dart';

class SearchScreen extends ConsumerWidget {
  final String query;
  const SearchScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(searchJokesProvider(query));

    return Scaffold(
      appBar: AppBar(title: Text('Wyniki dla: $query')),
      body: searchAsync.when(
        data: (jokes) {
          if (jokes.isEmpty) {
            return const Center(child: Text('Brak pasujących dowcipów.'));
          }
          return ListView.builder(
            itemCount: jokes.length,
            itemBuilder: (context, index) {
              final joke = jokes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Html(
                        data: joke.content,
                        style: {
                          "body": Style(fontSize: FontSize(16.0)),
                        },
                      ),
                      const SizedBox(height: 8),
                      Consumer(
                        builder: (context, ref, child) {
                          final favoritesAsync = ref.watch(favoritesProvider);
                          final isFav = favoritesAsync.value?.any((j) => j.id == joke.id) ?? joke.isFavorite;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                onPressed: () {
                                  ref.read(favoritesProvider.notifier).toggleFavorite(joke);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {
                                  final cleanText = joke.content.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
                                  Share.share(cleanText);
                                },
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Błąd: $error')),
      ),
    );
  }
}
