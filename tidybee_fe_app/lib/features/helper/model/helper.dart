class Helper {
  final String? id;
  final String? userId;
  final String? description;
  final int? hourlyRate;
  final bool? isAvailable;
  final double? rating;
  final int? reviewCount;
  final List<int>? services;
  final String? experience;
  final String? languages;
  final Map<String, dynamic>? location;
  final String? workingHoursStart;
  final String? workingHoursEnd;
  final List<int>? workingDays;
  final bool? backgroundChecked;
  final List<dynamic>? documents;
  final DateTime? createdAt;
  final String? helperName;
  final String? helperAvatar;

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
  });

  factory Helper.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return Helper(
      id: data['id']?.toString(),
      userId: data['userId']?.toString(),
      description: data['description']?.toString().trim(),
      hourlyRate: _parseInt(data['hourlyRate']),
      isAvailable: data['isAvailable'] as bool? ?? false,
      rating: data['rating'] != null
          ? double.tryParse(data['rating'].toString())
          : null,
      reviewCount: _parseInt(data['reviewCount']),
      services: data['services'] != null
          ? List<int>.from(data['services'].map((e) => _parseInt(e) ?? 0))
          : null,
      experience: data['experience']?.toString().trim(),
      languages: data['languages']?.toString().trim(),
      location: data['location'] is Map
          ? Map<String, dynamic>.from(data['location'])
          : null,
      workingHoursStart: data['workingHoursStart']?.toString(),
      workingHoursEnd: data['workingHoursEnd']?.toString(),
      workingDays: data['workingDays'] != null
          ? List<int>.from(data['workingDays'].map((e) => _parseInt(e) ?? 0))
          : null,
      backgroundChecked: data['backgroundChecked'] as bool? ?? false,
      documents: data['documents'] is List
          ? List<dynamic>.from(data['documents'])
          : null,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
      helperName: data['helperName']?.toString(),
      helperAvatar: data['helperAvatar']?.toString(),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
