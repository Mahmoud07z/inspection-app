import 'package:flutter/material.dart';

<<<<<<< HEAD
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({super.key, required this.message, this.onRetry});
=======
/// Full-screen error state with an optional retry button.
/// Use this inside [AsyncValue.when]'s `error` callback.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({super.key, required this.message, this.onRetry});

>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  final String message;
  final VoidCallback? onRetry;

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    ),
  );
=======
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
}
