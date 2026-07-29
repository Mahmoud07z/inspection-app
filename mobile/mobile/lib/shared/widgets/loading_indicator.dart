import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
/// Centred loading spinner used for full-screen async states.
/// Use this inside [AsyncValue.when]'s `loading` callback.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.message});
  final String? message;

  @override
<<<<<<< HEAD
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(message!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    ),
  );
=======
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
}
