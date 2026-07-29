import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
/// Themed [TextFormField] wrapper with consistent styling across all forms.
/// Accepts all the properties needed by feature forms without exposing
/// low-level [InputDecoration] boilerplate.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
<<<<<<< HEAD
=======
    this.hint,
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
<<<<<<< HEAD
    this.maxLines = 1,
  });

  final String label;
=======
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
  });

  final String label;
  final String? hint;
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
<<<<<<< HEAD
  final int maxLines;
=======
  final bool enabled;
  final int maxLines;
  final int? minLines;
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
<<<<<<< HEAD
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
=======
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
