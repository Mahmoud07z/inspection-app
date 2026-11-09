import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/users/models/user.dart';
import 'package:inspection_app/features/users/providers/users_provider.dart';
import 'package:inspection_app/shared/widgets/app_form_dialog.dart';
import 'package:inspection_app/shared/widgets/app_drawer.dart';
import 'package:inspection_app/shared/widgets/error_display.dart';
import 'package:inspection_app/shared/widgets/loading_indicator.dart';
import 'package:inspection_app/shared/widgets/workspace_app_bar.dart';

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
      appBar: const WorkspaceAppBar(title: 'Users'),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              _Chip(null, _role, _onRole),
              _Chip('ADMIN', _role, _onRole),
              _Chip('INSPECTOR', _role, _onRole),
            ]),
          ),
          Expanded(
            child: state.when(
              loading: () => const LoadingIndicator(),
              error: (e, _) => ErrorDisplay(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(usersProvider)),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final user = list[i];
                        return _UserTile(
                          user: user,
                          onEdit: () => _editUser(context, ref, user),
                          onDelete: () => _deleteUser(context, ref, user),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editUser(context, ref, null),
        icon: const Icon(Icons.person_add),
        label: const Text('User'),
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
  const _UserTile(
      {required this.user, required this.onEdit, required this.onDelete});
  final AppUser user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
              user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )),
        ),
        title: Text(user.fullName.isNotEmpty ? user.fullName : user.username),
        subtitle: Text(user.email, style: const TextStyle(fontSize: 12)),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => action == 'edit' ? onEdit() : onDelete(),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      );
}

Future<void> _editUser(
    BuildContext context, WidgetRef ref, AppUser? user) async {
  final username = TextEditingController(text: user?.username ?? '');
  final email = TextEditingController(text: user?.email ?? '');
  final fullName = TextEditingController(text: user?.fullName ?? '');
  final password = TextEditingController();
  var role = user?.role ?? 'INSPECTOR';
  final fields = <Widget>[
    TextFormField(
        controller: username,
        enabled: user == null,
        decoration: const InputDecoration(labelText: 'Username'),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter a username' : null),
    TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (value) => value == null || !value.contains('@')
            ? 'Enter a valid email'
            : null),
    TextFormField(
        controller: fullName,
        decoration: const InputDecoration(labelText: 'Full name'),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Enter a full name' : null),
    DropdownButtonFormField<String>(
      initialValue: role,
      decoration: const InputDecoration(labelText: 'Role'),
      items: const [
        DropdownMenuItem(value: 'INSPECTOR', child: Text('Inspector')),
        DropdownMenuItem(value: 'ADMIN', child: Text('Administrator')),
      ],
      onChanged: (value) {
        if (value != null) role = value;
      },
    ),
    if (user == null)
      TextFormField(
          controller: password,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: 'Password (at least 8 characters)'),
          validator: (value) => value == null || value.length < 8
              ? 'Use at least 8 characters'
              : null),
  ];
  await showAppFormDialog(
    context: context,
    title: user == null ? 'New user' : 'Edit user',
    fields: fields,
    onSave: () => user == null
        ? ref.read(usersProvider.notifier).add({
            'username': username.text.trim(),
            'email': email.text.trim(),
            'fullName': fullName.text.trim(),
            'role': role,
            'password': password.text,
          })
        : ref.read(usersProvider.notifier).updateItem(user.id, {
            'email': email.text.trim(),
            'fullName': fullName.text.trim(),
            'role': role,
          }),
  );
  username.dispose();
  email.dispose();
  fullName.dispose();
  password.dispose();
}

Future<void> _deleteUser(
    BuildContext context, WidgetRef ref, AppUser user) async {
  if (!await confirmDelete(context, user.username)) return;
  try {
    await ref.read(usersProvider.notifier).remove(user.id);
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
