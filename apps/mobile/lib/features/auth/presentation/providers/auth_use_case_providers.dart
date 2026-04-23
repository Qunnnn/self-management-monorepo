import 'package:mobile/core/import/app_imports.dart';

part 'auth_use_case_providers.g.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}
