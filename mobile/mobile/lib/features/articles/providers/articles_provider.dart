import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/articles/models/article.dart';
import 'package:inspection_app/features/articles/services/article_service.dart';

final articlesProvider =
    AsyncNotifierProvider<ArticlesNotifier, List<Article>>(ArticlesNotifier.new);

class ArticlesNotifier extends AsyncNotifier<List<Article>> {
  @override
  Future<List<Article>> build() => ref.read(articleServiceProvider).getAll();

  Future<void> search(String? q) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(articleServiceProvider).getAll(q: q?.isEmpty == true ? null : q));
  }

  Future<void> add(Map<String, dynamic> body) async {
    final a = await ref.read(articleServiceProvider).create(body);
    state = AsyncData([...?state.valueOrNull, a]);
  }

  Future<void> remove(int id) async {
    await ref.read(articleServiceProvider).delete(id);
    state = AsyncData(state.valueOrNull?.where((a) => a.id != id).toList() ?? []);
  }
}
