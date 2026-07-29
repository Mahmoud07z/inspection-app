import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
/// Full-width primary action button with an inline loading state.
///
/// Set [isLoading] to swap the label for a spinner and disable the tap —
/// no need to manage [onPressed] nullability separately.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
<<<<<<< HEAD
              height: 22, width: 22,
=======
              height: 22,
              width: 22,
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
<<<<<<< HEAD
                if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
=======
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
    );
  }
}
