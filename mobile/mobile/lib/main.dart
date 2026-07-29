import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  // ProviderScope is the root Riverpod container.
  // Every Provider / AsyncNotifierProvider is lazily initialised inside it.
=======

  // ProviderScope is the root Riverpod container.
  // Every Provider, AsyncNotifierProvider, etc. declared anywhere in the app
  // is initialised lazily inside this scope.
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  runApp(const ProviderScope(child: InspectionApp()));
}
