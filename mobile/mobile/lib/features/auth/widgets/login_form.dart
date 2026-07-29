import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/utils/validators.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';
import 'package:inspection_app/shared/widgets/app_button.dart';
import 'package:inspection_app/shared/widgets/app_text_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey  = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authProvider.notifier).login(
      _userCtrl.text.trim(),
      _passCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider).isLoading;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            label: 'Username',
            controller: _userCtrl,
            validator: Validators.username,
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            controller: _passCtrl,
            validator: Validators.password,
            obscureText: _hide,
            prefixIcon: Icons.lock_outline,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            suffixIcon: IconButton(
              icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _hide = !_hide),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(label: 'Sign In', icon: Icons.login, isLoading: loading, onPressed: _submit),
        ],
      ),
    );
  }
}
