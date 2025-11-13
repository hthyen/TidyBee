class HelperProfileSummaryModel {
  final bool success;
  final HelperProfileSummaryData? data;

  HelperProfileSummaryModel({required this.success, this.data});

  factory HelperProfileSummaryModel.fromJson(Map<String, dynamic> json) {
    return HelperProfileSummaryModel(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? HelperProfileSummaryData.fromJson(json['data'])
          : null,
    );
  }
}

class HelperProfileSummaryData {
  final HelperProfile profile;
  final int totalReviews;
  final double averageRating;

  HelperProfileSummaryData({
    required this.profile,
    required this.totalReviews,
    required this.averageRating,
  });

  factory HelperProfileSummaryData.fromJson(Map<String, dynamic> json) {
    return HelperProfileSummaryData(
      profile: HelperProfile.fromJson(json['profile']),
      totalReviews: json['summary']['totalReviews'] ?? 0,
      averageRating:
          (json['summary']['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class HelperProfile {
  final String userId;
  final double rating;
  final int reviewCount;
  final int hourlyRate;
  final bool isAvailable;
  final List<int> services;

  HelperProfile({
    required this.userId,
    required this.rating,
    required this.reviewCount,
    required this.hourlyRate,
    required this.isAvailable,
    required this.services,
  });

  factory HelperProfile.fromJson(Map<String, dynamic> json) {
    return HelperProfile(
      userId: json['userId'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      hourlyRate: json['hourlyRate'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      services: List<int>.from(json['services'] ?? []),
    );
  }
}
