// User Profile & Farm Info
class FarmProfile {
  String farmerName;
  String email;
  String phone;
  String farmName;
  String location;
  String chickenType; // Taga (Layers), Nyama (Broilers), Kienyeji, Mixed
  int totalChickens;
  String housingSystem; // Banda la Wavu, Banda la Sakafu, Mfumo wa Betri (Cage)
  String status; // Hai (Active)

  FarmProfile({
    required this.farmerName,
    required this.email,
    required this.phone,
    required this.farmName,
    required this.location,
    required this.chickenType,
    required this.totalChickens,
    required this.housingSystem,
    this.status = 'Kawaida (Salama)',
  });
}

// Today Summary Statistics
class TodaySummary {
  int eggsCollected;
  int sickChickens;
  int mortality;
  double feedRemainingKg;
  double todayIncomeTsz;
  double productivityPercentage;

  TodaySummary({
    required this.eggsCollected,
    required this.sickChickens,
    required this.mortality,
    required this.feedRemainingKg,
    required this.todayIncomeTsz,
    required this.productivityPercentage,
  });
}

// Marketplace Item Model
class MarketplaceItem {
  final String id;
  final String title;
  final String category; // Vyakula, Chanjo, Dawa, Vifaa, Mayai, Kuku, Samadi
  final double price;
  final String unit; // TSh/Kilo, TSh/Trei, TSh/Kuku
  final String description;
  final String sellerName;
  final String sellerPhone;
  final String location;
  final String imageUrl;
  final bool isForSale; // true = Uza, false = Nunua

  MarketplaceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.unit,
    required this.description,
    required this.sellerName,
    required this.sellerPhone,
    required this.location,
    required this.imageUrl,
    this.isForSale = true,
  });
}

// Daily Production Log Entry
class ProductionLog {
  final DateTime date;
  final int eggs;
  final double feedKg;
  final double waterLiters;
  final int mortality;
  final double birdAvgWeightKg;
  final double expensesTsz;

  ProductionLog({
    required this.date,
    required this.eggs,
    required this.feedKg,
    required this.waterLiters,
    required this.mortality,
    required this.birdAvgWeightKg,
    required this.expensesTsz,
  });
}

// Feed Inventory Item
class FeedInventoryItem {
  final String name;
  double currentStockKg;
  double totalCapacityKg;
  final String type; // Mash, Pellets, Starter, Finisher
  final double costPerKg;

  FeedInventoryItem({
    required this.name,
    required this.currentStockKg,
    required this.totalCapacityKg,
    required this.type,
    required this.costPerKg,
  });

  double get percentage => (currentStockKg / totalCapacityKg) * 100;
  bool get isLowStock => percentage < 25;
}

// Vaccination Calendar Schedule Item
class VaccinationItem {
  final String diseaseName;
  final String vaccineName;
  final String targetAge; // Siku ya 1, Siku ya 7, Wiki ya 3, etc.
  final DateTime scheduledDate;
  bool isCompleted;
  final String instructions;

  VaccinationItem({
    required this.diseaseName,
    required this.vaccineName,
    required this.targetAge,
    required this.scheduledDate,
    this.isCompleted = false,
    required this.instructions,
  });
}

// Sick Chicken AI Diagnosis Report
class SickChickenReport {
  final DateTime timestamp;
  final String symptomsText;
  final String? imageOrVideoUrl;
  final String diagnosedDisease;
  final String confidenceLevel;
  final String recommendedAction;
  final List<String> recommendedMedicines;
  final String urgency; // Ya Dharura, Kawaida, Kidogo

  SickChickenReport({
    required this.timestamp,
    required this.symptomsText,
    this.imageOrVideoUrl,
    required this.diagnosedDisease,
    required this.confidenceLevel,
    required this.recommendedAction,
    required this.recommendedMedicines,
    required this.urgency,
  });
}

// Chatbot Message Model
class ChatMessage {
  final String sender; // 'user' au 'kuku_ai'
  final String text;
  final DateTime timestamp;
  final bool isVetRecommendation;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isVetRecommendation = false,
  });
}

// Notification Alert Model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final String type; // Chanjo, Chakula, Soko, Ugonjwa
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

// Financial Record Model
class FinanceRecord {
  final String id;
  final String type; // Mapato (Income) au Matumizi (Expense)
  final String category; // Mauzo ya Mayai, Mauzo ya Kuku, Vyakula, Dawa, Vifaa
  final double amount;
  final DateTime date;
  final String description;

  FinanceRecord({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });
}

// Vet Doctor Profile Model
class VetProfile {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviewCount;
  final String phone;
  final bool isAvailable;

  VetProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    this.isAvailable = true,
  });
}
