import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String productionUrl = 'http://www.kukudiary.com/api';
  static const String localUrl = 'http://192.168.1.52:8000/api';
  static const String _fromEnv = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_fromEnv.isNotEmpty) return _fromEnv;
    return kReleaseMode ? productionUrl : localUrl;
  }
}
