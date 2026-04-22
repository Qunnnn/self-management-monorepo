import 'package:mobile/core/import/app_imports.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ProviderScope(
      observers: [
        AppRiverPodObserver(),
      ],
      child: const App(),
    ),
  );
}
