DateTime _parseDate(dynamic value) {
  if (value == null || value.toString().isEmpty) return DateTime.now();
  return DateTime.tryParse(value.toString()) ?? DateTime.now();
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value == null) return false;
  return value.toString().toLowerCase() == 'true' || value.toString() == '1';
}

class FarmProfile {
  String farmerName;
  String email;
  String phone;
  String farmName;
  String location;
  double latitude;
  double longitude;
  String farmSize;
  String chickenType;
  int totalChickens;
  String housingSystem;
  String status;
  String qrCodeData;
  bool setupComplete;

  FarmProfile({
    required this.farmerName,
    required this.email,
    required this.phone,
    required this.farmName,
    required this.location,
    this.latitude = 0,
    this.longitude = 0,
    this.farmSize = '',
    required this.chickenType,
    required this.totalChickens,
    required this.housingSystem,
    this.status = 'Salama / Operational',
    this.qrCodeData = '',
    this.setupComplete = false,
  });

  String get initial => farmerName.isNotEmpty ? farmerName[0].toUpperCase() : '?';

  factory FarmProfile.empty() => FarmProfile(
        farmerName: '',
        email: '',
        phone: '',
        farmName: '',
        location: '',
        chickenType: '',
        totalChickens: 0,
        housingSystem: '',
      );

  factory FarmProfile.fromJson(Map<String, dynamic> json) {
    return FarmProfile(
      farmerName: json['farmer_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      farmName: json['farm_name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      farmSize: json['farm_size']?.toString() ?? '',
      chickenType: json['chicken_type']?.toString() ?? '',
      totalChickens: _toInt(json['total_chickens']),
      housingSystem: json['housing_system']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Salama / Operational',
      qrCodeData: json['qr_code_data']?.toString() ?? '',
      setupComplete: _toBool(json['setup_complete']),
    );
  }

  Map<String, dynamic> toJson() => {
        'farmer_name': farmerName,
        'email': email,
        'phone': phone,
        'farm_name': farmName,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'farm_size': farmSize,
        'chicken_type': chickenType,
        'total_chickens': totalChickens,
        'housing_system': housingSystem,
        'status': status,
      };
}

class TodaySummary {
  int eggsCollected;
  int healthyChickens;
  int sickChickens;
  int mortality;
  double feedRemainingKg;
  double todayIncomeTsz;
  double productivityPercentage;

  TodaySummary({
    required this.eggsCollected,
    required this.healthyChickens,
    required this.sickChickens,
    required this.mortality,
    required this.feedRemainingKg,
    required this.todayIncomeTsz,
    required this.productivityPercentage,
  });

  factory TodaySummary.empty() => TodaySummary(
        eggsCollected: 0,
        healthyChickens: 0,
        sickChickens: 0,
        mortality: 0,
        feedRemainingKg: 0,
        todayIncomeTsz: 0,
        productivityPercentage: 0,
      );

  factory TodaySummary.fromJson(Map<String, dynamic> json) {
    return TodaySummary(
      eggsCollected: _toInt(json['eggs_collected']),
      healthyChickens: _toInt(json['healthy_chickens']),
      sickChickens: _toInt(json['sick_chickens']),
      mortality: _toInt(json['mortality']),
      feedRemainingKg: _toDouble(json['feed_remaining_kg']),
      todayIncomeTsz: _toDouble(json['today_income_tsz']),
      productivityPercentage: _toDouble(json['productivity_percentage']),
    );
  }
}

class PoultryBatch {
  final String id;
  final String breed;
  final int quantity;
  final String age;
  final DateTime datePurchased;
  final String supplier;
  final String notes;

  PoultryBatch({
    required this.id,
    required this.breed,
    required this.quantity,
    required this.age,
    required this.datePurchased,
    required this.supplier,
    this.notes = '',
  });

  factory PoultryBatch.fromJson(Map<String, dynamic> json) {
    return PoultryBatch(
      id: json['id']?.toString() ?? '',
      breed: json['breed']?.toString() ?? '',
      quantity: _toInt(json['quantity']),
      age: json['age']?.toString() ?? '',
      datePurchased: _parseDate(json['date_purchased']),
      supplier: json['supplier']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'breed': breed,
        'quantity': quantity,
        'age': age,
        'date_purchased': datePurchased.toIso8601String(),
        'supplier': supplier,
        'notes': notes,
      };
}

class MarketplaceItem {
  final String id;
  final String title;
  final String category;
  final double price;
  final String unit;
  final String description;
  final String sellerName;
  final String sellerPhone;
  final String location;
  final String imageUrl;
  final bool isForSale;

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

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    return MarketplaceItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: _toDouble(json['price']),
      unit: json['unit']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sellerName: json['seller_name']?.toString() ?? '',
      sellerPhone: json['seller_phone']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      isForSale: _toBool(json['is_for_sale'] ?? true),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category,
        'price': price,
        'unit': unit,
        'description': description,
        'image_url': imageUrl,
        'is_for_sale': isForSale,
      };
}

class ProductionLog {
  final String id;
  final DateTime date;
  final int eggs;
  final double feedKg;
  final double waterLiters;
  final int mortality;
  final double birdAvgWeightKg;
  final double expensesTsz;
  final String notes;

  ProductionLog({
    this.id = '',
    required this.date,
    required this.eggs,
    required this.feedKg,
    required this.waterLiters,
    required this.mortality,
    required this.birdAvgWeightKg,
    required this.expensesTsz,
    this.notes = '',
  });

  factory ProductionLog.fromJson(Map<String, dynamic> json) {
    return ProductionLog(
      id: json['id']?.toString() ?? '',
      date: _parseDate(json['date']),
      eggs: _toInt(json['eggs']),
      feedKg: _toDouble(json['feed_kg']),
      waterLiters: _toDouble(json['water_liters']),
      mortality: _toInt(json['mortality']),
      birdAvgWeightKg: _toDouble(json['bird_avg_weight_kg']),
      expensesTsz: _toDouble(json['expenses_tsz']),
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'eggs': eggs,
        'feed_kg': feedKg,
        'water_liters': waterLiters,
        'mortality': mortality,
        'bird_avg_weight_kg': birdAvgWeightKg,
        'expenses_tsz': expensesTsz,
        'notes': notes,
      };
}

class FeedInventoryItem {
  final String id;
  final String name;
  double currentStockKg;
  double totalCapacityKg;
  final String type;
  final double costPerKg;

  FeedInventoryItem({
    this.id = '',
    required this.name,
    required this.currentStockKg,
    required this.totalCapacityKg,
    required this.type,
    required this.costPerKg,
  });

  double get percentage => totalCapacityKg > 0 ? (currentStockKg / totalCapacityKg) * 100 : 0;
  bool get isLowStock => percentage < 25;

  factory FeedInventoryItem.fromJson(Map<String, dynamic> json) {
    return FeedInventoryItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      currentStockKg: _toDouble(json['current_stock_kg']),
      totalCapacityKg: _toDouble(json['total_capacity_kg']),
      type: json['type']?.toString() ?? '',
      costPerKg: _toDouble(json['cost_per_kg']),
    );
  }
}

class VaccinationItem {
  final String id;
  final String diseaseName;
  final String vaccineName;
  final String targetAge;
  final DateTime scheduledDate;
  bool isCompleted;
  final String instructions;
  final String itemType;

  VaccinationItem({
    required this.id,
    required this.diseaseName,
    required this.vaccineName,
    required this.targetAge,
    required this.scheduledDate,
    this.isCompleted = false,
    required this.instructions,
    this.itemType = 'vaccine',
  });

  factory VaccinationItem.fromJson(Map<String, dynamic> json) {
    return VaccinationItem(
      id: json['id']?.toString() ?? '',
      diseaseName: json['disease_name']?.toString() ?? '',
      vaccineName: json['vaccine_name']?.toString() ?? '',
      targetAge: json['target_age']?.toString() ?? '',
      scheduledDate: _parseDate(json['scheduled_date']),
      isCompleted: _toBool(json['is_completed']),
      instructions: json['instructions']?.toString() ?? '',
      itemType: json['item_type']?.toString() ?? 'vaccine',
    );
  }

  Map<String, dynamic> toJson() => {
        'disease_name': diseaseName,
        'vaccine_name': vaccineName,
        'target_age': targetAge,
        'scheduled_date': scheduledDate.toIso8601String(),
        'is_completed': isCompleted,
        'instructions': instructions,
        'item_type': itemType,
      };
}

class SickChickenReport {
  final String id;
  final DateTime timestamp;
  final String symptomsText;
  final String? imageOrVideoUrl;
  final String diagnosedDisease;
  final String confidenceLevel;
  final String recommendedAction;
  final List<String> recommendedMedicines;
  final String urgency;

  SickChickenReport({
    required this.id,
    required this.timestamp,
    required this.symptomsText,
    this.imageOrVideoUrl,
    required this.diagnosedDisease,
    required this.confidenceLevel,
    required this.recommendedAction,
    required this.recommendedMedicines,
    required this.urgency,
  });

  factory SickChickenReport.fromJson(Map<String, dynamic> json) {
    final medicines = json['recommended_medicines'];
    return SickChickenReport(
      id: json['id']?.toString() ?? '',
      timestamp: _parseDate(json['timestamp']),
      symptomsText: json['symptoms_text']?.toString() ?? '',
      imageOrVideoUrl: json['image_or_video_url']?.toString(),
      diagnosedDisease: json['diagnosed_disease']?.toString() ?? '',
      confidenceLevel: json['confidence_level']?.toString() ?? '',
      recommendedAction: json['recommended_action']?.toString() ?? '',
      recommendedMedicines: medicines is List ? medicines.map((e) => e.toString()).toList() : <String>[],
      urgency: json['urgency']?.toString() ?? '',
    );
  }
}

class VetConsultation {
  final String id;
  final String vetId;
  final String vetName;
  final String consultationType;
  final DateTime requestedTime;
  final String symptomsOrNotes;
  final String status;
  final String? doctorPrescription;
  final String? uploadedMediaUrl;

  VetConsultation({
    required this.id,
    required this.vetId,
    required this.vetName,
    required this.consultationType,
    required this.requestedTime,
    required this.symptomsOrNotes,
    this.status = 'Pending',
    this.doctorPrescription,
    this.uploadedMediaUrl,
  });

  factory VetConsultation.fromJson(Map<String, dynamic> json) {
    return VetConsultation(
      id: json['id']?.toString() ?? '',
      vetId: json['vet_id']?.toString() ?? '',
      vetName: json['vet_name']?.toString() ?? '',
      consultationType: json['consultation_type']?.toString() ?? '',
      requestedTime: _parseDate(json['requested_time']),
      symptomsOrNotes: json['symptoms_or_notes']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      doctorPrescription: json['doctor_prescription']?.toString(),
      uploadedMediaUrl: json['uploaded_media_url']?.toString(),
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isVetRecommendation;
  final String? imageUrl;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isVetRecommendation = false,
    this.imageUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      sender: json['sender']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      timestamp: _parseDate(json['timestamp']),
      isVetRecommendation: _toBool(json['is_vet_recommendation']),
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final String type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      time: _parseDate(json['time']),
      type: json['type']?.toString() ?? '',
      isRead: _toBool(json['is_read']),
    );
  }
}

class FinanceRecord {
  final String id;
  final String type;
  final String category;
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

  factory FinanceRecord.fromJson(Map<String, dynamic> json) {
    return FinanceRecord(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      amount: _toDouble(json['amount']),
      date: _parseDate(json['date']),
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
        'description': description,
      };
}

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

  factory VetProfile.fromJson(Map<String, dynamic> json) {
    return VetProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      rating: _toDouble(json['rating']),
      reviewCount: _toInt(json['review_count']),
      phone: json['phone']?.toString() ?? '',
      isAvailable: _toBool(json['is_available'] ?? true),
    );
  }
}

class ServiceProvider {
  final String id;
  final String name;
  final String category;
  final String location;
  final String phone;
  final String rating;
  final String description;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.phone,
    required this.rating,
    required this.description,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

class TrainingModule {
  final String id;
  final String title;
  final String category;
  final String contentType;
  final String durationOrReadTime;
  final String summary;
  final String contentDetails;
  final String videoUrl;
  final List<QuizQuestion>? quizQuestions;

  TrainingModule({
    required this.id,
    required this.title,
    required this.category,
    required this.contentType,
    required this.durationOrReadTime,
    required this.summary,
    required this.contentDetails,
    this.videoUrl = '',
    this.quizQuestions,
  });

  factory TrainingModule.fromJson(Map<String, dynamic> json) {
    final quizzes = json['quiz_questions'];
    return TrainingModule(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      contentType: json['content_type']?.toString() ?? '',
      durationOrReadTime: json['duration_or_read_time']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      contentDetails: json['content_details']?.toString() ?? '',
      videoUrl: json['video_url']?.toString() ?? '',
      quizQuestions: quizzes is List
          ? quizzes.whereType<Map>().map((q) => QuizQuestion.fromJson(Map<String, dynamic>.from(q))).toList()
          : null,
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final options = json['options'];
    return QuizQuestion(
      question: json['question']?.toString() ?? '',
      options: options is List ? options.map((e) => e.toString()).toList() : <String>[],
      correctOptionIndex: _toInt(json['correct_option_index']),
    );
  }
}

class CommunityPost {
  final String id;
  final String authorName;
  final String authorLocation;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  int likesCount;
  List<String> comments;
  bool isLiked;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likesCount = 0,
    required this.comments,
    this.isLiked = false,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final comments = json['comments'];
    return CommunityPost(
      id: json['id']?.toString() ?? '',
      authorName: json['author_name']?.toString() ?? '',
      authorLocation: json['author_location']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      timestamp: _parseDate(json['timestamp']),
      likesCount: _toInt(json['likes_count']),
      comments: comments is List ? comments.map((e) => e.toString()).toList() : <String>[],
      isLiked: _toBool(json['is_liked']),
    );
  }
}
