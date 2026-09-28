import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../services/api_service.dart';
import '../utils/l10n.dart';

class AppState extends ChangeNotifier {
  final ApiService _api = ApiService();

  String _currentRoute = 'splash';
  int _currentBottomNavIndex = 0;
  String _activeDrawerModule = 'dashboard';

  bool _isDarkMode = false;
  String _selectedLanguage = 'sw';
  bool _isBusy = false;
  String? _errorMessage;
  String? _debugOtp;
  String? _pendingIdentifier;
  String _pendingOtpPurpose = 'register';
  bool _sessionReady = false;

  FarmProfile _farmProfile = FarmProfile.empty();
  TodaySummary _todaySummary = TodaySummary.empty();
  final List<PoultryBatch> _poultryBatches = [];
  final List<ProductionLog> _productionLogs = [];
  final List<FeedInventoryItem> _feedInventory = [];
  final List<VaccinationItem> _vaccinations = [];
  final List<MarketplaceItem> _marketplaceItems = [];
  final List<ServiceProvider> _serviceProviders = [];
  final List<TrainingModule> _trainingModules = [];
  final List<CommunityPost> _communityPosts = [];
  final List<FinanceRecord> _financeRecords = [];
  final List<AppNotification> _notifications = [];
  final List<ChatMessage> _chatMessages = [];
  final List<VetProfile> _vets = [];
  final List<VetConsultation> _vetConsultations = [];
  final List<SickChickenReport> _sickChickenReports = [];

  String tr(String key) => L10n.tr(_selectedLanguage, key);

  String get currentRoute => _currentRoute;
  int get currentBottomNavIndex => _currentBottomNavIndex;
  String get activeDrawerModule => _activeDrawerModule;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  String? get debugOtp => _debugOtp;
  String? get pendingIdentifier => _pendingIdentifier;
  String get pendingOtpPurpose => _pendingOtpPurpose;
  bool get isLoggedIn => _api.token != null && _api.token!.isNotEmpty;
  FarmProfile get farmProfile => _farmProfile;
  TodaySummary get todaySummary => _todaySummary;
  List<PoultryBatch> get poultryBatches => _poultryBatches;
  List<ProductionLog> get productionLogs => _productionLogs;
  List<FeedInventoryItem> get feedInventory => _feedInventory;
  List<VaccinationItem> get vaccinations => _vaccinations;
  List<MarketplaceItem> get marketplaceItems => _marketplaceItems;
  List<ServiceProvider> get serviceProviders => _serviceProviders;
  List<TrainingModule> get trainingModules => _trainingModules;
  List<CommunityPost> get communityPosts => _communityPosts;
  List<FinanceRecord> get financeRecords => _financeRecords;
  List<AppNotification> get notifications => _notifications;
  List<ChatMessage> get chatMessages => _chatMessages;
  List<SickChickenReport> get sickChickenReports => _sickChickenReports;
  List<VetConsultation> get vetConsultations => _vetConsultations;
  List<VetProfile> get vets => _vets;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  int get unreadNotificationCount => unreadNotificationsCount;

  Future<void>? _restoreJob;

  AppState() {
    restoreSession();
  }

  Future<void> restoreSession() {
    return _restoreJob ??= _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    _api.token = prefs.getString('auth_token');
    _sessionReady = true;
    if (_api.token == null || _api.token!.isEmpty) {
      notifyListeners();
      return;
    }
    try {
      await refreshFromServer();
    } catch (_) {
      _api.token = null;
      await prefs.remove('auth_token');
      notifyListeners();
    }
  }

  void setRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  void setBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    switch (index) {
      case 0:
        _activeDrawerModule = 'dashboard';
        break;
      case 1:
        _activeDrawerModule = 'veterinary';
        break;
      case 2:
        _activeDrawerModule = 'marketplace';
        break;
      case 3:
        _activeDrawerModule = 'vaccination';
        break;
      case 4:
        _activeDrawerModule = 'production';
        break;
    }
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    setRoute('login');
  }

  Future<String> resolvePostSplashRoute() async {
    await restoreSession();
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    if (isLoggedIn && _farmProfile.setupComplete) return 'main_shell';
    if (isLoggedIn) return 'farm_setup';
    if (seen) return 'login';
    return 'onboarding';
  }

  int feedDaysRemainingEstimate() {
    if (_feedInventory.isEmpty) return 0;
    final stock = _todaySummary.feedRemainingKg;
    if (stock <= 0) return 0;
    final logs = _productionLogs;
    final dailyUse = logs.isNotEmpty ? logs.last.feedKg : 0;
    if (dailyUse <= 0) return 0;
    return (stock / dailyUse).ceil();
  }

  String greetingForNow() {
    final hour = DateTime.now().hour;
    final isSw = _selectedLanguage == 'sw';
    if (hour < 12) return isSw ? 'Habari za Asubuhi' : 'Good Morning';
    if (hour < 17) return isSw ? 'Habari za Mchana' : 'Good Afternoon';
    return isSw ? 'Habari za Jioni' : 'Good Evening';
  }

  void setActiveDrawerModule(String moduleName) {
    _activeDrawerModule = moduleName;
    _currentRoute = 'main_shell';
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _api.updateSettings({'is_dark_mode': _isDarkMode});
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
    _api.updateSettings({'language': lang});
  }

  Future<void> _storeToken(String token) async {
    _api.token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _clearToken() async {
    _api.token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  List<T> _list<T>(dynamic raw, T Function(Map<String, dynamic>) map) {
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => map(Map<String, dynamic>.from(e))).toList();
  }

  void _applyBootstrap(Map<String, dynamic> data) {
    if (data['farm_profile'] is Map) {
      _farmProfile = FarmProfile.fromJson(Map<String, dynamic>.from(data['farm_profile'] as Map));
    }
    if (data['today_summary'] is Map) {
      _todaySummary = TodaySummary.fromJson(Map<String, dynamic>.from(data['today_summary'] as Map));
    }
    if (data['settings'] is Map) {
      final settings = Map<String, dynamic>.from(data['settings'] as Map);
      _isDarkMode = settings['is_dark_mode'] == true;
      _selectedLanguage = settings['language']?.toString() ?? _selectedLanguage;
    }
    _poultryBatches
      ..clear()
      ..addAll(_list(data['poultry_batches'], PoultryBatch.fromJson));
    _productionLogs
      ..clear()
      ..addAll(_list(data['production_logs'], ProductionLog.fromJson));
    _feedInventory
      ..clear()
      ..addAll(_list(data['feed_inventory'], FeedInventoryItem.fromJson));
    _vaccinations
      ..clear()
      ..addAll(_list(data['vaccinations'], VaccinationItem.fromJson));
    _marketplaceItems
      ..clear()
      ..addAll(_list(data['marketplace_items'], MarketplaceItem.fromJson));
    _serviceProviders
      ..clear()
      ..addAll(_list(data['service_providers'], ServiceProvider.fromJson));
    _trainingModules
      ..clear()
      ..addAll(_list(data['training_modules'], TrainingModule.fromJson));
    _communityPosts
      ..clear()
      ..addAll(_list(data['community_posts'], CommunityPost.fromJson));
    _financeRecords
      ..clear()
      ..addAll(_list(data['finance_records'], FinanceRecord.fromJson));
    _notifications
      ..clear()
      ..addAll(_list(data['notifications'], AppNotification.fromJson));
    _chatMessages
      ..clear()
      ..addAll(_list(data['chat_messages'], ChatMessage.fromJson));
    _vets
      ..clear()
      ..addAll(_list(data['vets'], VetProfile.fromJson));
    _vetConsultations
      ..clear()
      ..addAll(_list(data['vet_consultations'], VetConsultation.fromJson));
    _sickChickenReports
      ..clear()
      ..addAll(_list(data['sick_chicken_reports'], SickChickenReport.fromJson));
  }

  Future<void> refreshFromServer() async {
    final data = await _api.bootstrap();
    _applyBootstrap(data);
    notifyListeners();
  }

  Future<void> _afterAuth(Map<String, dynamic> payload, {required bool fromRegister}) async {
    final token = payload['token']?.toString();
    if (token == null || token.isEmpty) {
      throw ApiException('No auth token returned.');
    }
    await _storeToken(token);
    await refreshFromServer();
    if (fromRegister || _farmProfile.setupComplete == false) {
      _currentRoute = 'farm_setup';
    } else {
      _currentRoute = 'main_shell';
      _activeDrawerModule = 'dashboard';
    }
    notifyListeners();
  }

  Future<String?> register({
    required String farmerName,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _api.register(
        farmerName: farmerName,
        phone: phone,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      await _afterAuth(data, fromRegister: true);
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<String?> login(String identifier, String password) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _api.login(identifier, password);
      await _afterAuth(data, fromRegister: false);
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<String?> requestPasswordReset(String identifier) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _api.forgotPassword(identifier);
      _pendingIdentifier = data['identifier']?.toString() ?? identifier;
      _pendingOtpPurpose = 'reset';
      _debugOtp = data['otp']?.toString();
      return _debugOtp;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String code, {String? newPassword}) async {
    final identifier = _pendingIdentifier;
    if (identifier == null || identifier.isEmpty) {
      throw ApiException('No phone/email pending verification.');
    }
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final data = await _api.verifyOtp(
        identifier: identifier,
        code: code,
        purpose: _pendingOtpPurpose,
        newPassword: newPassword,
      );
      if (data['token'] != null) {
        await _afterAuth(data, fromRegister: _pendingOtpPurpose == 'register');
      } else {
        _currentRoute = 'login';
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _api.logout();
    await _clearToken();
    _farmProfile = FarmProfile.empty();
    _todaySummary = TodaySummary.empty();
    _poultryBatches.clear();
    _productionLogs.clear();
    _feedInventory.clear();
    _vaccinations.clear();
    _marketplaceItems.clear();
    _communityPosts.clear();
    _financeRecords.clear();
    _notifications.clear();
    _chatMessages.clear();
    _vetConsultations.clear();
    _sickChickenReports.clear();
    _currentRoute = 'login';
    notifyListeners();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final data = await _api.changePassword(oldPassword, newPassword);
    final token = data['token']?.toString();
    if (token != null) await _storeToken(token);
  }

  Future<void> updateFarmSetup({
    required String farmName,
    required String location,
    required String chickenType,
    required int totalChickens,
    required String housingSystem,
    String farmSize = '',
    double latitude = 0,
    double longitude = 0,
    String? farmerName,
    String? phone,
  }) async {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _farmProfile = await _api.updateFarm({
        'farmer_name': farmerName ?? _farmProfile.farmerName,
        'email': _farmProfile.email,
        'phone': phone ?? _farmProfile.phone,
        'farm_name': farmName,
        'location': location,
        'chicken_type': chickenType,
        'total_chickens': totalChickens,
        'housing_system': housingSystem,
        'farm_size': farmSize,
        'latitude': latitude,
        'longitude': longitude,
      });
      _currentRoute = 'main_shell';
      _activeDrawerModule = 'dashboard';
      await refreshFromServer();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> updateFarmGps(double latitude, double longitude, {String? location}) async {
    _farmProfile = await _api.updateFarm({
      ..._farmProfile.toJson(),
      'latitude': latitude,
      'longitude': longitude,
      if (location != null) 'location': location,
    });
    notifyListeners();
  }

  Future<void> addPoultryBatch(PoultryBatch batch) async {
    final created = await _api.createBatch(batch);
    _poultryBatches.insert(0, created);
    _farmProfile.totalChickens += created.quantity;
    notifyListeners();
    await refreshFromServer();
  }

  Future<void> addProductionLog(ProductionLog log) async {
    await _api.createProductionLog(log);
    await refreshFromServer();
  }

  Future<void> addFeedStock(String type, double kgAdded) async {
    await _api.addFeedStock(type, kgAdded);
    await refreshFromServer();
  }

  Future<void> addMarketplaceItem(MarketplaceItem item) async {
    final created = await _api.createMarketplaceItem(item);
    _marketplaceItems.insert(0, created);
    notifyListeners();
  }

  Future<void> toggleVaccinationCompleted(int index) async {
    final item = _vaccinations[index];
    final updated = await _api.patchVaccination(item.id, {'is_completed': !item.isCompleted});
    _vaccinations[index] = updated;
    notifyListeners();
  }

  Future<void> addVaccinationSchedule(VaccinationItem item) async {
    await _api.createVaccination(item);
    await refreshFromServer();
  }

  Future<void> bookVetConsultation({
    required String vetId,
    required String vetName,
    required String consultationType,
    required String symptomsOrNotes,
    String? mediaUrl,
  }) async {
    await _api.bookConsultation({
      'vet_id': vetId,
      'vet_name': vetName,
      'consultation_type': consultationType,
      'symptoms_or_notes': symptomsOrNotes,
      'requested_time': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
      'uploaded_media_url': mediaUrl ?? '',
    });
    await refreshFromServer();
  }

  Future<void> addCommunityPost(String title, String content, String? imageUrl) async {
    final created = await _api.createCommunityPost(title, content);
    _communityPosts.insert(0, created);
    notifyListeners();
  }

  Future<void> togglePostLike(String postId) async {
    final updated = await _api.toggleLike(postId);
    final index = _communityPosts.indexWhere((p) => p.id == postId);
    if (index != -1) _communityPosts[index] = updated;
    notifyListeners();
  }

  Future<void> addCommentToPost(String postId, String commentText) async {
    final updated = await _api.addComment(postId, commentText);
    final index = _communityPosts.indexWhere((p) => p.id == postId);
    if (index != -1) _communityPosts[index] = updated;
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  Future<void> addFinanceRecord(FinanceRecord record) async {
    await _api.createFinance(record);
    await refreshFromServer();
  }

  Future<void> markNotificationAsRead(String id) async {
    final updated = await _api.markNotificationRead(id);
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) _notifications[index] = updated;
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    await _api.clearNotifications();
    _notifications.clear();
    notifyListeners();
  }

  Future<void> sendChatMessage(String text) async {
    _chatMessages.add(ChatMessage(sender: 'user', text: text, timestamp: DateTime.now()));
    notifyListeners();
    try {
      await _api.sendChat(text);
      await refreshFromServer();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<SickChickenReport> performAIDiagnosis(String symptoms, String? imagePath) async {
    final report = await _api.diagnose(symptoms, imagePath);
    _sickChickenReports.insert(0, report);
    notifyListeners();
    await refreshFromServer();
    return report;
  }
}
