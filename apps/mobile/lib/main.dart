import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/observers/app_riverpod_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ProviderScope(
      observers: [
        AppRiverpodObserver(),
      ],
      child: const App(),
    ),
  );
}
