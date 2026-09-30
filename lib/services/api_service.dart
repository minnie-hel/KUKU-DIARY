import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/models.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  String? token;

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Token $token';
    }
    return headers;
  }

  Uri _uri(String path) {
    final base = ApiConfig.baseUrl.replaceAll(RegExp(r'/$'), '');
    final clean = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$clean');
  }

  dynamic _decode(http.Response response) {
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return response.body;
    }
  }

  String _errorMessage(dynamic body, int status) {
    if (body is String && body.contains('<html')) {
      return 'Seva haikukubali ombi hili ($status). Jaribu tena baada ya muda mfupi.';
    }
    if (body is Map) {
      if (body['detail'] != null) return body['detail'].toString();
      if (body['message'] != null) return body['message'].toString();
      final parts = <String>[];
      body.forEach((key, value) {
        parts.add('$key: $value');
      });
      if (parts.isNotEmpty) return parts.join('\n');
    }
    return 'Request failed ($status)';
  }

  static const Duration _timeout = Duration(seconds: 20);
  static const String _offlineMessage =
      'Haiwezi kufikia seva ya KUKU DIARY. Hakikisha una intaneti/Wi-Fi na seva inafanya kazi.\n'
      '(Cannot reach the KUKU DIARY server. Check your connection and that the server is running.)';

  Future<dynamic> _send(String method, String path, {Object? body, bool auth = true}) async {
    final uri = _uri(path);
    final headers = Map<String, String>.from(_headers);
    if (!auth) headers.remove('Authorization');
    http.Response response;
    final encoded = body == null ? null : jsonEncode(body);
    try {
      switch (method) {
        case 'GET':
          response = await http.get(uri, headers: headers).timeout(_timeout);
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: encoded).timeout(_timeout);
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: encoded).timeout(_timeout);
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: encoded).timeout(_timeout);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(_timeout);
          break;
        default:
          throw ApiException('Unsupported method $method');
      }
    } on SocketException {
      throw ApiException(_offlineMessage);
    } on TimeoutException {
      throw ApiException(_offlineMessage);
    } on http.ClientException {
      throw ApiException(_offlineMessage);
    }
    final decoded = _decode(response);
    if (response.statusCode >= 400) {
      throw ApiException(_errorMessage(decoded, response.statusCode), response.statusCode);
    }
    return decoded;
  }

  Future<Map<String, dynamic>> register({
    required String farmerName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return Map<String, dynamic>.from(await _send('POST', '/auth/register/', body: {
      'farmer_name': farmerName,
      'phone': phone,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    }, auth: false));
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String identifier,
    required String code,
    String purpose = 'register',
    String? newPassword,
  }) async {
    if (purpose == 'reset' && newPassword != null) {
      return Map<String, dynamic>.from(await _send('POST', '/auth/reset-password/', body: {
        'identifier': identifier,
        'code': code,
        'new_password': newPassword,
      }, auth: false));
    }
    return Map<String, dynamic>.from(await _send('POST', '/auth/verify-otp/', body: {
      'identifier': identifier,
      'code': code,
      'purpose': purpose,
    }, auth: false));
  }

  Future<Map<String, dynamic>> login(String identifier, String password) async {
    return Map<String, dynamic>.from(await _send('POST', '/auth/login/', body: {
      'identifier': identifier,
      'password': password,
    }, auth: false));
  }

  Future<Map<String, dynamic>> requestOtp(String identifier, {String purpose = 'login'}) async {
    return Map<String, dynamic>.from(await _send('POST', '/auth/request-otp/', body: {
      'identifier': identifier,
      'purpose': purpose,
    }, auth: false));
  }

  Future<Map<String, dynamic>> forgotPassword(String identifier) async {
    return Map<String, dynamic>.from(await _send('POST', '/auth/forgot-password/', body: {
      'identifier': identifier,
    }, auth: false));
  }

  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    return Map<String, dynamic>.from(await _send('POST', '/auth/change-password/', body: {
      'old_password': oldPassword,
      'new_password': newPassword,
    }));
  }

  Future<void> logout() async {
    try {
      await _send('POST', '/auth/logout/');
    } catch (_) {}
  }

  Future<Map<String, dynamic>> bootstrap() async {
    return Map<String, dynamic>.from(await _send('GET', '/bootstrap/'));
  }

  Future<FarmProfile> updateFarm(Map<String, dynamic> data) async {
    return FarmProfile.fromJson(Map<String, dynamic>.from(await _send('POST', '/farm/', body: data)));
  }

  Future<void> updateSettings(Map<String, dynamic> data) async {
    await _send('POST', '/settings/', body: data);
  }

  Future<PoultryBatch> createBatch(PoultryBatch batch) async {
    return PoultryBatch.fromJson(Map<String, dynamic>.from(await _send('POST', '/poultry-batches/', body: batch.toJson())));
  }

  Future<ProductionLog> createProductionLog(ProductionLog log) async {
    return ProductionLog.fromJson(Map<String, dynamic>.from(await _send('POST', '/production-logs/', body: log.toJson())));
  }

  Future<FeedInventoryItem> addFeedStock(String type, double kgAdded) async {
    return FeedInventoryItem.fromJson(Map<String, dynamic>.from(await _send('POST', '/feed-inventory/add_stock/', body: {
      'type': type,
      'kg_added': kgAdded,
    })));
  }

  Future<MarketplaceItem> createMarketplaceItem(MarketplaceItem item) async {
    return MarketplaceItem.fromJson(Map<String, dynamic>.from(await _send('POST', '/marketplace/', body: item.toJson())));
  }

  Future<VaccinationItem> createVaccination(VaccinationItem item) async {
    return VaccinationItem.fromJson(Map<String, dynamic>.from(await _send('POST', '/vaccinations/', body: item.toJson())));
  }

  Future<VaccinationItem> patchVaccination(String id, Map<String, dynamic> data) async {
    return VaccinationItem.fromJson(Map<String, dynamic>.from(await _send('POST', '/vaccinations/$id/update_item/', body: data)));
  }

  Future<VetConsultation> bookConsultation(Map<String, dynamic> data) async {
    return VetConsultation.fromJson(Map<String, dynamic>.from(await _send('POST', '/vet-consultations/', body: data)));
  }

  Future<CommunityPost> createCommunityPost(String title, String content) async {
    return CommunityPost.fromJson(Map<String, dynamic>.from(await _send('POST', '/community/', body: {
      'title': title,
      'content': content,
    })));
  }

  Future<CommunityPost> toggleLike(String postId) async {
    return CommunityPost.fromJson(Map<String, dynamic>.from(await _send('POST', '/community/$postId/like/')));
  }

  Future<CommunityPost> addComment(String postId, String text) async {
    return CommunityPost.fromJson(Map<String, dynamic>.from(await _send('POST', '/community/$postId/comments/', body: {
      'text': text,
    })));
  }

  Future<FinanceRecord> createFinance(FinanceRecord record) async {
    return FinanceRecord.fromJson(Map<String, dynamic>.from(await _send('POST', '/finance/', body: record.toJson())));
  }

  Future<AppNotification> markNotificationRead(String id) async {
    return AppNotification.fromJson(Map<String, dynamic>.from(await _send('POST', '/notifications/$id/read/')));
  }

  Future<void> clearNotifications() async {
    await _send('POST', '/notifications/clear/');
  }

  Future<Map<String, dynamic>> sendChat(String text) async {
    return Map<String, dynamic>.from(await _send('POST', '/chat/', body: {'text': text}));
  }

  Future<SickChickenReport> diagnose(String symptoms, String? imagePath) async {
    if (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync()) {
      final request = http.MultipartRequest('POST', _uri('/disease-reports/diagnose/'));
      if (token != null) request.headers['Authorization'] = 'Token $token';
      request.fields['symptoms_text'] = symptoms;
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      http.Response response;
      try {
        final streamed = await request.send().timeout(const Duration(seconds: 60));
        response = await http.Response.fromStream(streamed);
      } on SocketException {
        throw ApiException(_offlineMessage);
      } on TimeoutException {
        throw ApiException(_offlineMessage);
      } on http.ClientException {
        throw ApiException(_offlineMessage);
      }
      final decoded = _decode(response);
      if (response.statusCode >= 400) {
        throw ApiException(_errorMessage(decoded, response.statusCode), response.statusCode);
      }
      return SickChickenReport.fromJson(Map<String, dynamic>.from(decoded as Map));
    }
    return SickChickenReport.fromJson(Map<String, dynamic>.from(await _send('POST', '/disease-reports/diagnose/', body: {
      'symptoms_text': symptoms,
    })));
  }
}
