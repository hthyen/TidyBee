class Helper {
  final String? id;
  final String? userId;
  final String? description;
  final int? hourlyRate;
  final bool? isAvailable;
  final double? rating;
  final int? reviewCount;
  final List<String>? services;
  final String? experience;
  final String? languages;
  final String? location;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final List<String>? workingDays;
  final bool? backgroundChecked;
  final List<dynamic>? documents;
  final DateTime? createdAt;
  final String? helperName;
  final String? helperAvatar;

  final Map<String, dynamic>? locationData;

  Helper({
    this.id,
    this.userId,
    this.description,
    this.hourlyRate,
    this.isAvailable,
    this.rating,
    this.reviewCount,
    this.services,
    this.experience,
    this.languages,
    this.location,
    this.workingHoursStart,
    this.workingHoursEnd,
    this.workingDays,
    this.backgroundChecked,
    this.documents,
    this.createdAt,
    this.helperName,
    this.helperAvatar,
    this.locationData,
  });

  factory Helper.fromJson(Map<String, dynamic> json) {
    return Helper(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      description: json['description'],
      hourlyRate: json['hourlyRate'] is int
          ? json['hourlyRate']
          : int.tryParse(json['hourlyRate']?.toString() ?? ''),
      isAvailable: json['isAvailable'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      reviewCount: json['reviewCount'] is int
          ? json['reviewCount']
          : int.tryParse(json['reviewCount']?.toString() ?? ''),
      services: json['services'] != null
          ? List<String>.from(json['services'])
          : [],
      experience: json['experience'],
      languages: json['languages'],
      location: json['location'],

      locationData: json['locationData'] != null
          ? Map<String, dynamic>.from(json['locationData'])
          : null,

      workingHoursStart: json['workingHoursStart'],
      workingHoursEnd: json['workingHoursEnd'],
      workingDays: json['workingDays'] != null
          ? List<String>.from(json['workingDays'])
          : [],
      backgroundChecked: json['backgroundChecked'] ?? false,
      documents: json['documents'] ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      helperName: json['helperName'],
      helperAvatar: json['helperAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "description": description,
      "hourlyRate": hourlyRate,
      "isAvailable": isAvailable,
      "rating": rating,
      "reviewCount": reviewCount,
      "services": services,
      "experience": experience,
      "languages": languages,
      "location": location,
      "locationData": locationData,
      "workingHoursStart": workingHoursStart,
      "workingHoursEnd": workingHoursEnd,
      "workingDays": workingDays,
      "backgroundChecked": backgroundChecked,
      "documents": documents,
      "createdAt": createdAt?.toIso8601String(),
      "helperName": helperName,
      "helperAvatar": helperAvatar,
    };
  }
}
