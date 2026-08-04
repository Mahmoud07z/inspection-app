import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ProviderScope is the root Riverpod container.
  // Every Provider, AsyncNotifierProvider, etc. declared anywhere in the app
  // is initialised lazily inside this scope.
  runApp(const ProviderScope(child: InspectionApp()));
}
