import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inspection_app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ProviderScope is the root Riverpod container.
  // Every Provider / AsyncNotifierProvider is lazily initialised inside it.
  runApp(const ProviderScope(child: InspectionApp()));
}
