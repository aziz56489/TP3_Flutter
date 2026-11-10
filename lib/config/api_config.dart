import 'package:flutter/foundation.dart';

class ApiConfig {
  static const int port = 3000;

  static const Duration timeout = Duration(seconds: 10);

  static String get baseUrl {
    if(kIsWeb) return 'http://localhost:$port';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$port';
    }
    return 'http://localhost:$port';
  }
}
