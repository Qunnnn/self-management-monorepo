import 'dart:io';

class NetworkConfig {
  static String get baseURL {
    // For iOS simulator: localhost
    // For Android emulator: 10.0.2.2
    // For physical devices: Machine IP
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }
}
