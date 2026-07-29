import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/constants/api_constants.dart';
import 'package:inspection_app/features/articles/models/article.dart';
import 'package:inspection_app/shared/services/api_service.dart';

final articleServiceProvider = Provider<ArticleService>(
  (ref) => ArticleService(ref.read(apiServiceProvider)),
);

class ArticleService {
  ArticleService(this._api);
  final ApiService _api;

  Future<List<Article>> getAll({String? q}) async {
    final r = await _api.client.get(ApiConstants.articles,
        queryParameters: q != null ? {'q': q} : null);
    return (r.data as List).map((e) => Article.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Article> getById(int id) async {
    final r = await _api.client.get(ApiConstants.articleById(id));
    return Article.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Article> create(Map<String, dynamic> body) async {
    final r = await _api.client.post(ApiConstants.articles, data: body);
    return Article.fromJson(r.data as Map<String, dynamic>);
  }

  Future<Article> update(int id, Map<String, dynamic> body) async {
    final r = await _api.client.put(ApiConstants.articleById(id), data: body);
    return Article.fromJson(r.data as Map<String, dynamic>);
  }

  Future<void> delete(int id) => _api.client.delete(ApiConstants.articleById(id));
}
