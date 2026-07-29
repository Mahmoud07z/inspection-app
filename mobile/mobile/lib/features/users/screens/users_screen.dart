import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/users/models/user.dart';
import 'package:inspection_app/features/users/providers/users_provider.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _State();
}

class _State extends ConsumerState<UsersScreen> {
  String? _role;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              _Chip(null,        _role, _onRole),
              _Chip('ADMIN',     _role, _onRole),
              _Chip('INSPECTOR', _role, _onRole),
            ]),
          ),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorDisplay(message: e.toString(), onRetry: () => ref.invalidate(usersProvider)),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) => _UserTile(user: list[i]),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* TODO: create user form */},
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _onRole(String? role) {
    setState(() => _role = role);
    ref.read(usersProvider.notifier).filterByRole(role);
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.role, this.active, this.onSelected);
  final String? role, active;
  final void Function(String?) onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: FilterChip(
      label: Text(role ?? 'All'),
      selected: active == role,
      onSelected: (_) => onSelected(role),
    ),
  );
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: CircleAvatar(
      backgroundColor: user.role == 'ADMIN'
          ? const Color(0xFFE8F5E9)
          : const Color(0xFFE3F2FD),
      child: Text(user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
          style: const TextStyle(fontWeight: FontWeight.w700)),
    ),
    title: Text(user.fullName.isNotEmpty ? user.fullName : user.username),
    subtitle: Text(user.email, style: const TextStyle(fontSize: 12)),
    trailing: Chip(
      label: Text(user.role, style: const TextStyle(fontSize: 11)),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      backgroundColor: user.role == 'ADMIN'
          ? const Color(0xFFE8F5E9)
          : const Color(0xFFE3F2FD),
    ),
  );
}
