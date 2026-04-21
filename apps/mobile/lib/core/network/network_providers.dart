import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dio_client.dart';
import 'token_storage.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage();
}

@Riverpod(keepAlive: true)
DioClient dioClient(Ref ref) {
  return DioClient(ref.watch(tokenStorageProvider));
}
