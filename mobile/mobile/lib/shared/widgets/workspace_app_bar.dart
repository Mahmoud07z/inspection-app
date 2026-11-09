import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inspection_app/core/navigation/route_names.dart';

/// App bar shared by top-level workspace sections, with an explicit route back
/// to the overview while retaining the drawer menu for section-to-section nav.
class WorkspaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WorkspaceAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.actions = const [],
  });

  final String title;
  final PreferredSizeWidget? bottom;
  final List<Widget> actions;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(title),
        bottom: bottom,
        actions: [
          ...actions,
          IconButton(
            tooltip: 'Return to overview',
            onPressed: () => context.go(RouteNames.dashboard),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 6),
        ],
      );
}
