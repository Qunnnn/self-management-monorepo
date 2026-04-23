import 'package:mobile/core/import/app_imports.dart';

part 'login_use_case_provider.g.dart';

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}
