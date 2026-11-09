import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/core/utils/validators.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';
import 'package:inspection_app/shared/models/api_error.dart';
import 'package:inspection_app/shared/widgets/app_button.dart';
import 'package:inspection_app/shared/widgets/app_text_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
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
    final authState = ref.watch(authProvider);
    final loading = authState.isLoading;
    final error = authState.hasError ? _messageFor(authState.error!) : null;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            label: 'Username',
            hint: 'Enter your username',
            autofillHints: const [AutofillHints.username],
            controller: _userCtrl,
            validator: Validators.username,
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            hint: 'Enter your password',
            autofillHints: const [AutofillHints.password],
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
          if (error != null) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: .35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 19),
                  const SizedBox(width: 9),
                  Expanded(
                      child: Text(error,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              height: 1.4))),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),
          AppButton(
              label: 'Sign in',
              icon: Icons.arrow_forward_rounded,
              isLoading: loading,
              onPressed: _submit),
          const SizedBox(height: 17),
          Text('Need access? Contact your system administrator.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.45)),
        ],
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is ApiError) return error.displayMessage;
    if (error is DioException) {
      if (error.error is ApiError) {
        return (error.error! as ApiError).displayMessage;
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'We couldn’t reach the server. Check your connection and try again.';
      }
      return 'Sign in could not be completed. Please try again.';
    }
    return 'Sign in could not be completed. Please try again.';
  }
}
