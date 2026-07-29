import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/articles/providers/articles_provider.dart';
import 'package:inspection_app/features/articles/widgets/article_tile.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

class ArticlesScreen extends ConsumerStatefulWidget {
  const ArticlesScreen({super.key});

  @override
  ConsumerState<ArticlesScreen> createState() => _State();
}

class _State extends ConsumerState<ArticlesScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(articlesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Search articles…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear),
                        onPressed: () { _ctrl.clear(); ref.read(articlesProvider.notifier).search(null); })
                    : null,
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              ),
              onChanged: (q) => ref.read(articlesProvider.notifier).search(q),
            ),
          ),
        ),
      ),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => ErrorDisplay(message: e.toString(), onRetry: () => ref.invalidate(articlesProvider)),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No articles found'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (_, i) => ArticleTile(article: list[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* TODO: create article form */},
        child: const Icon(Icons.add),
      ),
    );
  }
}
