import 'package:flutter/material.dart';

Future<bool?> showAppFormDialog({
  required BuildContext context,
  required String title,
  required List<Widget> fields,
  required Future<void> Function() onSave,
}) => showDialog<bool>(
      context: context,
      builder: (_) => _AppFormDialog(title: title, fields: fields, onSave: onSave),
    );

Future<bool> confirmDelete(BuildContext context, String label) async =>
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Delete $label? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ??
    false;

class _AppFormDialog extends StatefulWidget {
  const _AppFormDialog({required this.title, required this.fields, required this.onSave});
  final String title;
  final List<Widget> fields;
  final Future<void> Function() onSave;

  @override
  State<_AppFormDialog> createState() => _AppFormDialogState();
}

class _AppFormDialogState extends State<_AppFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  String? _error;

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _saving = true; _error = null; });
    try {
      await widget.onSave();
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) setState(() { _saving = false; _error = error.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: SizedBox(
          width: 440,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final field in widget.fields) ...[field, const SizedBox(height: 14)],
                  if (_error != null)
                    Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      );
}
