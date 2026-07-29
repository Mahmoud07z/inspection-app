import 'package:flutter/material.dart';
import 'package:inspection_app/features/articles/models/article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article, this.onTap});
  final Article article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFF1565C0)),
    title: Text(article.name, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(article.code,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.grey)),
    trailing: article.description != null
        ? Icon(Icons.info_outline, size: 18, color: Colors.grey[400])
        : null,
    onTap: onTap,
  );
}
