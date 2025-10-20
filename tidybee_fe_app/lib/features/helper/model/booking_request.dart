class BookingRequest {
  final String id;
  final String customerId;
  final int serviceType;
  final String title;
  final String description;
  final double budget;
  final DateTime scheduledDate;
  final int estimatedDuration;
  final String locationAddress;
  final double distanceKm;
  final int responseCount;

  BookingRequest({
    required this.id,
    required this.customerId,
    required this.serviceType,
    required this.title,
    required this.description,
    required this.budget,
    required this.scheduledDate,
    required this.estimatedDuration,
    required this.locationAddress,
    required this.distanceKm,
    required this.responseCount,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      serviceType: json['serviceType'] ?? 0,
      title: json['title'] ?? 'Không có tiêu đề',
      description: json['description'] ?? 'Không có mô tả',
      budget: (json['budget'] ?? 0).toDouble(),
      scheduledDate:
          DateTime.tryParse(json['scheduledDate'] ?? '') ?? DateTime.now(),
      estimatedDuration: json['estimatedDuration'] ?? 0,
      locationAddress: json['locationAddress'] ?? 'Không có địa chỉ',
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      responseCount: json['responseCount'] ?? 0,
    );
  }
}
