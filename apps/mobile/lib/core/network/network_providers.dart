import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';
import 'token_storage.dart';

part 'network_providers.g.dart';

@riverpod
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage();
}

@riverpod
DioClient dioClient(Ref ref) {
  return DioClient(ref.watch(tokenStorageProvider));
}
