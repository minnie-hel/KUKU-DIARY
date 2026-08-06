import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // Navigation / Route state
  String _currentRoute = 'splash'; // splash, onboarding, login, register, otp, farm_setup, main_shell
  int _currentBottomNavIndex = 0; // 0: Dashboard, 1: Records, 2: Marketplace, 3: Notifications, 4: Profile
  String _activeDrawerModule = 'dashboard'; // dashboard, veterinary, training, marketplace, production, feed, vaccination, finance, reports, calendar, ai_assistant, notifications, profile, settings

  // Settings state
  bool _isDarkMode = false;
  String _selectedLanguage = 'sw'; // 'sw' for Swahili, 'en' for English

  // User & Farm Profile
  final FarmProfile _farmProfile = FarmProfile(
    farmerName: 'Juma Hamisi',
    email: 'juma.hamisi@kukudiary.co.tz',
    phone: '+255 712 345 678',
    farmName: 'Kuku Bora Farm',
    location: 'Kibaha, Pwani',
    chickenType: 'Kuku wa Mayai (Layers)',
    totalChickens: 450,
    housingSystem: 'Mfumo wa Sakafu & Vituo',
    status: 'Kawaida (Salama)',
  );

  // Today's Summary
  final TodaySummary _todaySummary = TodaySummary(
    eggsCollected: 380,
    sickChickens: 2,
    mortality: 0,
    feedRemainingKg: 120.5,
    todayIncomeTsz: 190000.0,
    productivityPercentage: 84.4,
  );

  // Daily Production Logs
  final List<ProductionLog> _productionLogs = [
    ProductionLog(
      date: DateTime.now().subtract(const Duration(days: 6)),
      eggs: 350,
      feedKg: 50.0,
      waterLiters: 90.0,
      mortality: 1,
      birdAvgWeightKg: 1.8,
      expensesTsz: 45000.0,
    ),
    ProductionLog(
      date: DateTime.now().subtract(const Duration(days: 5)),
      eggs: 365,
      feedKg: 52.0,
      waterLiters: 92.0,
      mortality: 0,
      birdAvgWeightKg: 1.82,
      expensesTsz: 0.0,
    ),
    ProductionLog(
      date: DateTime.now().subtract(const Duration(days: 4)),
      eggs: 372,
      feedKg: 51.0,
      waterLiters: 91.0,
      mortality: 0,
      birdAvgWeightKg: 1.83,
      expensesTsz: 12000.0,
    ),
    ProductionLog(
      date: DateTime.now().subtract(const Duration(days: 3)),
      eggs: 360,
      feedKg: 50.0,
      waterLiters: 90.0,
      mortality: 0,
      birdAvgWeightKg: 1.85,
      expensesTsz: 0.0,
    ),
    ProductionLog(
      date: DateTime.now().subtract(const Duration(days: 2)),
      eggs: 378,
      feedKg: 53.0,
      waterLiters: 95.0,
      mortality: 1,
      birdAvgWeightKg: 1.86,
      expensesTsz: 30000.0,
    ),
    ProductionLog(
      date: DateTime.now().subtract(const Duration(days: 1)),
      eggs: 385,
      feedKg: 52.0,
      waterLiters: 94.0,
      mortality: 0,
      birdAvgWeightKg: 1.87,
      expensesTsz: 0.0,
    ),
    ProductionLog(
      date: DateTime.now(),
      eggs: 380,
      feedKg: 54.0,
      waterLiters: 96.0,
      mortality: 0,
      birdAvgWeightKg: 1.88,
      expensesTsz: 15000.0,
    ),
  ];

  // Feed Inventory Items
  final List<FeedInventoryItem> _feedInventory = [
    FeedInventoryItem(
      name: 'Layer Mash (Chakula cha Kuku wa Mayai)',
      currentStockKg: 120.5,
      totalCapacityKg: 500.0,
      type: 'Layer Mash',
      costPerKg: 1400.0,
    ),
    FeedInventoryItem(
      name: 'Chick Starter (Chakula cha Vifaranga)',
      currentStockKg: 35.0,
      totalCapacityKg: 200.0,
      type: 'Starter',
      costPerKg: 1800.0,
    ),
    FeedInventoryItem(
      name: 'Grower Pellets (Chakula cha Kukua)',
      currentStockKg: 15.0, // Low stock alert!
      totalCapacityKg: 300.0,
      type: 'Grower',
      costPerKg: 1600.0,
    ),
  ];

  // Vaccination Schedule
  final List<VaccinationItem> _vaccinations = [
    VaccinationItem(
      diseaseName: 'Kideri / Marec (Newcastle Disease)',
      vaccineName: 'Lasota / HB1',
      targetAge: 'Siku ya 7',
      scheduledDate: DateTime.now().subtract(const Duration(days: 20)),
      isCompleted: true,
      instructions: 'Weka kwenye maji ya kunywa asubuhi kabla ya jua kuwa kali.',
    ),
    VaccinationItem(
      diseaseName: 'Gumboro (Infectious Bursal)',
      vaccineName: 'Gumboro Intermediate',
      targetAge: 'Siku ya 14',
      scheduledDate: DateTime.now().subtract(const Duration(days: 13)),
      isCompleted: true,
      instructions: 'Changanya na maziwa ya unga kuzuia chlorine ya maji.',
    ),
    VaccinationItem(
      diseaseName: 'Ndui ya Kuku (Fowl Pox)',
      vaccineName: 'Fowl Pox Vaccine',
      targetAge: 'Wiki ya 6 (Siku 42)',
      scheduledDate: DateTime.now().add(const Duration(days: 4)),
      isCompleted: false,
      instructions: 'Choma kwenye bawa kwa kutumia sindano maalum ya mabawa miwili.',
    ),
    VaccinationItem(
      diseaseName: 'Kideri Awamu ya Pili (Newcastle Booster)',
      vaccineName: 'Lasota Booster',
      targetAge: 'Wiki ya 10',
      scheduledDate: DateTime.now().add(const Duration(days: 25)),
      isCompleted: false,
      instructions: 'Dondoshea tone moja kwenye jicho la kila kuku au kwenye maji.',
    ),
  ];

  // Marketplace Items
  final List<MarketplaceItem> _marketplaceItems = [
    MarketplaceItem(
      id: 'm1',
      title: 'Trei za Mayai ya Kienyeji Safi',
      category: 'Mayai',
      price: 13500.0,
      unit: 'TSh / Trei',
      description: 'Mayai mapya kutoka shamba la kienyeji. Ni makubwa na ya njano kabisa.',
      sellerName: 'Juma Hamisi',
      sellerPhone: '+255 712 345 678',
      location: 'Kibaha, Pwani',
      imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=400&q=80',
      isForSale: true,
    ),
    MarketplaceItem(
      id: 'm2',
      title: 'Chakula cha Kuku wa Mayai (Layer Mash 50kg)',
      category: 'Vyakula',
      price: 68000.0,
      unit: 'TSh / Mfuko',
      description: 'Chakula bora cha viwango vilivyothibitishwa kwa ajili ya kuongeza utagaji wa mayai.',
      sellerName: 'Mifugo Feeds Co.',
      sellerPhone: '+255 754 999 111',
      location: 'Mbezi, Dar es Salaam',
      imageUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=400&q=80',
      isForSale: false,
    ),
    MarketplaceItem(
      id: 'm3',
      title: 'Vifaranga wa Siku Moja (Kuku wa Mayai - ISA Brown)',
      category: 'Vifaranga',
      price: 2800.0,
      unit: 'TSh / Kifaranga',
      description: 'Vifaranga waliopata chanjo ya Mareks siku ya kwanza. Afya bora 100%.',
      sellerName: 'TanBroilers Hatchery',
      sellerPhone: '+255 788 222 333',
      location: 'Morogoro Mjini',
      imageUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=400&q=80',
      isForSale: false,
    ),
    MarketplaceItem(
      id: 'm4',
      title: 'Samadi ya Kuku (Kilio cha Rutuba 100kg)',
      category: 'Samadi',
      price: 15000.0,
      unit: 'TSh / Mfuko',
      description: 'Samadi kavu isiyo na harufu mbaya, inafaa kwa kilimo cha mboga na matunda.',
      sellerName: 'Juma Hamisi',
      sellerPhone: '+255 712 345 678',
      location: 'Kibaha, Pwani',
      imageUrl: 'https://images.unsplash.com/photo-1592417817098-8f3d6eb19657?auto=format&fit=crop&w=400&q=80',
      isForSale: true,
    ),
  ];

  // Financial Logs
  final List<FinanceRecord> _financeRecords = [
    FinanceRecord(
      id: 'f1',
      type: 'Mapato',
      category: 'Mauzo ya Mayai',
      amount: 190000.0,
      date: DateTime.now(),
      description: 'Mauzo ya trei 14 za mayai kwa duka la rejareja.',
    ),
    FinanceRecord(
      id: 'f2',
      type: 'Matumizi',
      category: 'Vyakula',
      amount: 68000.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Ununuzi wa mfuko mmoja wa Layer Mash 50kg.',
    ),
    FinanceRecord(
      id: 'f3',
      type: 'Matumizi',
      category: 'Dawa & Chanjo',
      amount: 15000.0,
      date: DateTime.now().subtract(const Duration(days: 4)),
      description: 'Ununuzi wa chanjo ya Gumboro & Multivitamin.',
    ),
    FinanceRecord(
      id: 'f4',
      type: 'Mapato',
      category: 'Mauzo ya Kuku',
      amount: 240000.0,
      date: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Mauzo ya kuku 20 waliomaliza kutaga.',
    ),
  ];

  // Notifications List
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Kumbukumbu ya Chanjo!',
      message: 'Siku 4 zimebaki kabla ya kuchoma Chanjo ya Ndui ya Kuku (Fowl Pox).',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'Chanjo',
      isRead: false,
    ),
    AppNotification(
      id: 'n2',
      title: 'Tahadhari ya Akiba ya Chakula',
      message: 'Akiba ya Grower Pellets iko chini ya 15% (15kg zimebaki). Tafadhali ongeza akiba.',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'Chakula',
      isRead: false,
    ),
    AppNotification(
      id: 'n3',
      title: 'Oda Mpya Sokoni!',
      message: 'Mteja Hashim anataka kununua Trei 5 za Mayai.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: 'Soko',
      isRead: true,
    ),
  ];

  // AI Chat Messages
  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      sender: 'kuku_ai',
      text: 'Habari Juma! Mimi ni KukuAI - Msaidizi wako wa digitali wa ufugaji kuku. Una swali gani leo kuhusu afya, utagaji au lishe ya kuku wako?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  // List of Vets
  final List<VetProfile> _vets = [
    VetProfile(
      id: 'v1',
      name: 'Dr. Elizabeth Mwangi',
      specialty: 'Daktari wa Ndege na Kuku',
      location: 'Kibaha, Pwani',
      rating: 4.9,
      reviewCount: 42,
      phone: '+255 754 111 222',
      isAvailable: true,
    ),
    VetProfile(
      id: 'v2',
      name: 'Dr. Hassan Juma',
      specialty: 'Mtaalamu wa Magonjwa ya Kuku',
      location: 'Dar es Salaam',
      rating: 4.8,
      reviewCount: 38,
      phone: '+255 788 333 444',
      isAvailable: true,
    ),
  ];

  // Sick Chicken Reports History
  final List<SickChickenReport> _sickChickenReports = [];

  // Getters
  String get currentRoute => _currentRoute;
  int get currentBottomNavIndex => _currentBottomNavIndex;
  String get activeDrawerModule => _activeDrawerModule;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  FarmProfile get farmProfile => _farmProfile;
  TodaySummary get todaySummary => _todaySummary;
  List<ProductionLog> get productionLogs => _productionLogs;
  List<FeedInventoryItem> get feedInventory => _feedInventory;
  List<VaccinationItem> get vaccinations => _vaccinations;
  List<MarketplaceItem> get marketplaceItems => _marketplaceItems;
  List<FinanceRecord> get financeRecords => _financeRecords;
  List<AppNotification> get notifications => _notifications;
  List<ChatMessage> get chatMessages => _chatMessages;
  List<SickChickenReport> get sickChickenReports => _sickChickenReports;
  List<VetProfile> get vets => _vets;

  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;
  int get unreadNotificationCount => unreadNotificationsCount;

  // State Modifiers

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
        _activeDrawerModule = 'production';
        break;
      case 2:
        _activeDrawerModule = 'marketplace';
        break;
      case 3:
        _activeDrawerModule = 'notifications';
        break;
      case 4:
        _activeDrawerModule = 'profile';
        break;
    }
    notifyListeners();
  }

  void setActiveDrawerModule(String moduleName) {
    _activeDrawerModule = moduleName;
    _currentRoute = 'main_shell';
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void updateFarmSetup({
    required String farmName,
    required String location,
    required String chickenType,
    required int totalChickens,
    required String housingSystem,
  }) {
    _farmProfile.farmName = farmName;
    _farmProfile.location = location;
    _farmProfile.chickenType = chickenType;
    _farmProfile.totalChickens = totalChickens;
    _farmProfile.housingSystem = housingSystem;
    _currentRoute = 'main_shell';
    _activeDrawerModule = 'dashboard';
    notifyListeners();
  }

  void addProductionLog(ProductionLog log) {
    _productionLogs.add(log);
    _todaySummary.eggsCollected = log.eggs;
    _todaySummary.mortality += log.mortality;
    _todaySummary.feedRemainingKg = (_todaySummary.feedRemainingKg - log.feedKg).clamp(0.0, 9999.0);
    _todaySummary.productivityPercentage = (log.eggs / _farmProfile.totalChickens) * 100;
    notifyListeners();
  }

  void addMarketplaceItem(MarketplaceItem item) {
    _marketplaceItems.insert(0, item);
    notifyListeners();
  }

  void addFeedStock(String feedName, double additionalKg) {
    for (var item in _feedInventory) {
      if (item.name == feedName) {
        item.currentStockKg += additionalKg;
        break;
      }
    }
    notifyListeners();
  }

  void toggleVaccinationCompleted(int index) {
    _vaccinations[index].isCompleted = !_vaccinations[index].isCompleted;
    notifyListeners();
  }

  void addVaccinationSchedule(VaccinationItem item) {
    _vaccinations.insert(0, item);
    // Automatically trigger notification for the user
    _notifications.insert(
      0,
      AppNotification(
        id: 'v_notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Kumbukumbu ya Chanjo: ${item.diseaseName}',
        message: 'Chanjo ya ${item.diseaseName} (${item.vaccineName}) imewekwa kwenye kalenda kwa ajili ya ${item.targetAge}. Tarehe: ${item.scheduledDate.day}/${item.scheduledDate.month}/${item.scheduledDate.year}.',
        time: DateTime.now(),
        type: 'Chanjo',
        isRead: false,
      ),
    );
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void addFinanceRecord(FinanceRecord record) {
    _financeRecords.insert(0, record);
    if (record.type == 'Mapato') {
      _todaySummary.todayIncomeTsz += record.amount;
    }
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    for (var n in _notifications) {
      if (n.id == id) {
        n.isRead = true;
        break;
      }
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // AI Chat Assistant Logic in Swahili
  void sendChatMessage(String text) {
    _chatMessages.add(ChatMessage(
      sender: 'user',
      text: text,
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1000), () {
      String responseText = _generateAIResponse(text);
      _chatMessages.add(ChatMessage(
        sender: 'kuku_ai',
        text: responseText,
        timestamp: DateTime.now(),
        isVetRecommendation: text.toLowerCase().contains('ugonjwa') || text.toLowerCase().contains('dawa') || text.toLowerCase().contains('kufa'),
      ));
      notifyListeners();
    });
  }

  String _generateAIResponse(String prompt) {
    String p = prompt.toLowerCase();
    if (p.contains('mayai') && (p.contains('kupungua') || p.contains('hawatagi'))) {
      return 'Kupungua kwa utagaji wa mayai kunaweza kusababishwa na:\n1. Mabadiliko ya chakula au chakula kisicho na protini ya kutosha (inahitajika 16-18%).\n2. Ukosefu wa maji safi na baridi.\n3. Msongo wa mawazo (Stress) mfano kelele au joto kali.\n4. Magonjwa kama Kideri (Newcastle) au Typhoid.\n\nUshauri: Hakikisha chakula kina calcium (chokaa) na maji yapo wakati wote.';
    } else if (p.contains('kula') || p.contains('hawali')) {
      return 'Kuku kutokula kunaashiria dalili za awali za ugonjwa au joto kali bandani.\n1. Angalia kama wanakohoa au kutoa kamasi.\n2. Angalia kinyesi chao (kama ni cha kijani, cheupe au cha damu).\n3. Wape maji yaliyochanganywa na Multivitamin na Glucose mara moja.';
    } else if (p.contains('kideri') || p.contains('newcastle')) {
      return 'Kideri ni ugonjwa wa virusi hatari sana. Dalili ni pamoja na kuku kupinda shingo, kinyesi cha kijani kibichi na kupooza.\n\nTiba: Hakuna tiba ya moja kwa moja ya virusi. Wape Multivitamin + Antibiotic kuzuia maambukizi ya sekondari. Hakikisha unawapa Chanjo ya Lasota mapema!';
    } else if (p.contains('dawa') || p.contains('nini')) {
      return 'Kabla ya kutoa dawa, ni muhimu kutambua chanzo cha tatizo. Kwa matatizo ya mfumo wa hewa (mafua), tumia Tylosin au Doxycycline. Kwa kinyesi cha damu (Coccidiosis), tumia Amprolium au ESB3.';
    } else {
      return 'Asante kwa swali lako. Kwa uzoefu wa KUKU DIARY, inashauriwa kufuatilia lishe bora, usafi wa banda, na chanjo kwa wakati. Kama dalili zinaendelea, tunashauri uweke miadi na Daktari wa Mifugo aliye karibu nawe.';
    }
  }

  // Sick Chicken AI Visual Diagnosis Simulation
  SickChickenReport performAIDiagnosis(String symptoms, String? imagePath) {
    SickChickenReport report;
    if (symptoms.toLowerCase().contains('kamasi') || symptoms.toLowerCase().contains('macho') || symptoms.toLowerCase().contains('mafua')) {
      report = SickChickenReport(
        timestamp: DateTime.now(),
        symptomsText: symptoms,
        imageOrVideoUrl: imagePath,
        diagnosedDisease: 'Mafua ya Kuku (Infectious Coryza)',
        confidenceLevel: '92%',
        urgency: 'Kawaida',
        recommendedAction: 'Tenga kuku wagonjwa mara moja kwenye banda la karantini. Safisha vyombo vya maji kwa dawa ya kuua vijidudu.',
        recommendedMedicines: ['Tylosin Powder', 'Doxycycline 20%', 'Multivitamin Stress Pack'],
      );
    } else if (symptoms.toLowerCase().contains('damu') || symptoms.toLowerCase().contains('kinyesi cha damu')) {
      report = SickChickenReport(
        timestamp: DateTime.now(),
        symptomsText: symptoms,
        imageOrVideoUrl: imagePath,
        diagnosedDisease: 'Kuhara Damu (Coccidiosis)',
        confidenceLevel: '95%',
        urgency: 'Ya Dharura',
        recommendedAction: 'Badilisha pumba au maranda ya chini (litter) kwani yana unyevu. Weka dawa kwenye maji kwa siku 5 mfululizo.',
        recommendedMedicines: ['Amprolium 20%', 'ESB3 Powder', 'Vitamin K3'],
      );
    } else {
      report = SickChickenReport(
        timestamp: DateTime.now(),
        symptomsText: symptoms,
        imageOrVideoUrl: imagePath,
        diagnosedDisease: 'Kideri / Newcastle Disease (Hatua ya Awali)',
        confidenceLevel: '88%',
        urgency: 'Ya Dharura',
        recommendedAction: 'Choma chanjo kwa kuku salama waliobaki. Weka kuku wenye ugonjwa mbali na kundi kuu.',
        recommendedMedicines: ['Lasota Vaccine', 'Antibiotics for Secondary Infection', 'Vitalytes Plus'],
      );
    }
    _sickChickenReports.insert(0, report);
    _todaySummary.sickChickens += 1;
    notifyListeners();
    return report;
  }
}
