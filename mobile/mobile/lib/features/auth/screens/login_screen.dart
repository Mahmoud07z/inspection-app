import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/features/auth/providers/auth_provider.dart';
import 'package:inspection_app/features/auth/widgets/login_form.dart';
import 'package:inspection_app/shared/models/api_error.dart';

<<<<<<< HEAD
=======
/// The only unauthenticated screen in the app.
/// Displays a SnackBar when [authProvider] transitions to [AsyncError].
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<dynamic>>(authProvider, (_, next) {
      if (next.hasError) {
        final err = next.error;
        final msg = err is ApiError ? err.displayMessage : err.toString();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
<<<<<<< HEAD
          ..showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700));
=======
          ..showSnackBar(SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade700,
          ));
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warehouse, size: 56, color: Color(0xFF1565C0)),
                const SizedBox(height: 16),
<<<<<<< HEAD
                Text('Sign in',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text('Inspection App',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey)),
=======
                Text(
                  'Sign in',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Inspection App',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
                const SizedBox(height: 40),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
