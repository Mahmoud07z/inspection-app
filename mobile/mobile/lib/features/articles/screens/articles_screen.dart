import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/articles/providers/articles_provider.dart';
import 'package:inspection_app/features/articles/widgets/article_tile.dart';
import 'package:inspection_app/features/articles/models/article.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/shared/widgets/workspace_app_bar.dart';
import 'package:inspection_app/shared/widgets/qr_scanner_dialog.dart';

class ArticlesScreen extends ConsumerStatefulWidget {
  const ArticlesScreen({super.key});

  @override
  ConsumerState<ArticlesScreen> createState() => _State();
}

class _State extends ConsumerState<ArticlesScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(articlesProvider);
    return Scaffold(
      appBar: WorkspaceAppBar(
        title: 'Articles',
        actions: [
          IconButton(
            tooltip: 'Scan article QR code',
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: _scanArticleCode,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Search articles…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _ctrl.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _ctrl.clear();
                            setState(() {});
                            ref.read(articlesProvider.notifier).search(null);
                          },
                        )
                        : null,
                isDense: true,
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onChanged: (q) {
                setState(() {});
                ref.read(articlesProvider.notifier).search(q);
              },
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: state.when(
        loading: () => const LoadingIndicator(),
        error:
            (e, _) => ErrorDisplay(
              message: e.toString(),
              onRetry: () => ref.invalidate(articlesProvider),
            ),
        data:
            (list) =>
                list.isEmpty
                    ? const Center(child: Text('No articles found'))
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (_, i) {
                        final article = list[i];
                        return ArticleTile(
                          article: article,
                          onTap: () => _editArticle(context, ref, article),
                          onEdit: () => _editArticle(context, ref, article),
                          onDelete: () => _deleteArticle(context, ref, article),
                        );
                      },
                    ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editArticle(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('Article'),
      ),
    );
  }

  Future<void> _scanArticleCode() async {
    final code = await scanQrCode(context);
    if (!mounted || code == null) return;
    _ctrl.text = code;
    setState(() {});
    await ref.read(articlesProvider.notifier).search(code);
    if (!mounted) return;

    final results = ref.read(articlesProvider).valueOrNull ?? const <Article>[];
    final match =
        results
            .where(
              (article) => article.code.toLowerCase() == code.toLowerCase(),
            )
            .firstOrNull;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          match == null
              ? 'No article matches QR code "$code".'
              : 'Article found: ${match.name}',
        ),
      ),
    );
  }
}

Future<void> _editArticle(
  BuildContext context,
  WidgetRef ref,
  Article? article,
) async {
  final code = TextEditingController(text: article?.code ?? '');
  final name = TextEditingController(text: article?.name ?? '');
  final description = TextEditingController(text: article?.description ?? '');
  await showAppFormDialog(
    context: context,
    title: article == null ? 'New article' : 'Edit article',
    fields: [
      TextFormField(
        controller: code,
        enabled: article == null,
        decoration: InputDecoration(
          labelText: 'SKU / article code',
          suffixIcon:
              article == null
                  ? IconButton(
                    tooltip: 'Scan QR into article code',
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    onPressed: () async {
                      final scannedCode = await scanQrCode(context);
                      if (context.mounted && scannedCode != null) {
                        code.text = scannedCode;
                      }
                    },
                  )
                  : null,
        ),
        validator:
            (value) =>
                value == null || value.trim().isEmpty ? 'Enter a code' : null,
      ),
      TextFormField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Name'),
        validator:
            (value) =>
                value == null || value.trim().isEmpty ? 'Enter a name' : null,
      ),
      TextFormField(
        controller: description,
        maxLines: 3,
        decoration: const InputDecoration(labelText: 'Description'),
      ),
    ],
    onSave:
        () =>
            article == null
                ? ref.read(articlesProvider.notifier).add({
                  'code': code.text.trim(),
                  'name': name.text.trim(),
                  'description':
                      description.text.trim().isEmpty
                          ? null
                          : description.text.trim(),
                })
                : ref.read(articlesProvider.notifier).updateItem(article.id, {
                  'name': name.text.trim(),
                  'description':
                      description.text.trim().isEmpty
                          ? null
                          : description.text.trim(),
                }),
  );
  code.dispose();
  name.dispose();
  description.dispose();
}

Future<void> _deleteArticle(
  BuildContext context,
  WidgetRef ref,
  Article article,
) async {
  if (!await confirmDelete(context, article.name)) return;
  try {
    await ref.read(articlesProvider.notifier).remove(article.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
