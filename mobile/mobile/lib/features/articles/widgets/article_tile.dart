import 'package:flutter/material.dart';
import 'package:inspection_app/features/articles/models/article.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile(
      {super.key,
      required this.article,
      this.onTap,
      this.onEdit,
      this.onDelete});
  final Article article;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(Icons.inventory_2_outlined,
            color: Theme.of(context).colorScheme.primary),
        title: Text(article.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(article.code,
            style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        trailing: PopupMenuButton<String>(
          onSelected: (action) =>
              action == 'edit' ? onEdit?.call() : onDelete?.call(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: onTap,
      );
}
