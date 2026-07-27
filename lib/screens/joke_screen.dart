import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/jokes_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/favorites_provider.dart';

class JokeScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryName;
  const JokeScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends ConsumerState<JokeScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = ref.read(progressProvider)[widget.categoryId] ?? 0;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jokesAsync = ref.watch(jokesByCategoryProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: jokesAsync.when(
        data: (jokes) {
          if (jokes.isEmpty) {
            return const Center(child: Text('Brak dowcipów w tej kategorii.'));
          }
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: jokes.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    ref
                        .read(progressProvider.notifier)
                        .saveProgress(widget.categoryId, index);
                  },
                  itemBuilder: (context, index) {
                    final joke = jokes[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Html(
                        data: joke.content,
                        style: {"body": Style(fontSize: FontSize(18.0))},
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 150,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(56, 56),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        if (currentIndex > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        final favoritesAsync = ref.watch(favoritesProvider);
                        if (currentIndex >= jokes.length) {
                          return const SizedBox.shrink();
                        }

                        final currentJoke = jokes[currentIndex];
                        final isFav =
                            favoritesAsync.value?.any(
                              (j) => j.id == currentJoke.id,
                            ) ??
                            currentJoke.isFavorite;

                        return Row(
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(56, 56),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                              ),
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                ref
                                    .read(favoritesProvider.notifier)
                                    .toggleFavorite(currentJoke);
                              },
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(56, 56),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                              ),
                              icon: Icon(
                                Icons.share,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                              ),
                              onPressed: () {
                                final cleanText = currentJoke.content
                                    .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
                                Share.share(cleanText);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(56, 56),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        if (currentIndex < jokes.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Błąd: $error')),
      ),
    );
  }
}
