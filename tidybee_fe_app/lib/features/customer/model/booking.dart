class Booking {
  final int? serviceType;
  final String? title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? district;
  final String? ward;
  final DateTime? scheduledStartTime;
  final DateTime? scheduledEndTime;
  final double? estimatedPrice;
  final String? customerNotes;
  final bool? isRecurring;
  final String? recurringPattern;
  final DateTime? recurringEndDate;

  Booking({
    this.serviceType,
    this.title,
    this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.estimatedPrice,
    this.customerNotes,
    this.isRecurring,
    this.recurringPattern,
    this.recurringEndDate,
  });

  // Parse data from JSON into model
  factory Booking.fromJson(Map<String, dynamic> json) {
    final loc = json['serviceLocation'];
    return Booking(
      serviceType: json['serviceType'],
      title: json['title'],
      description: json['description'],
      latitude: (loc['latitude'] ?? 0).toDouble(),
      longitude: (loc['longitude'] ?? 0).toDouble(),
      address: loc['address'],
      city: loc['city'],
      district: loc['district'],
      ward: loc['ward'],
      scheduledStartTime: DateTime.parse(json['scheduledStartTime']),
      scheduledEndTime: DateTime.parse(json['scheduledEndTime']),
      estimatedPrice: json['estimatedPrice'],
      customerNotes: json['customerNotes'],
      isRecurring: json['isRecurring'],
      recurringPattern: json['recurringPattern'],
      recurringEndDate: json['recurringEndDate'] != null
          ? DateTime.parse(json['recurringEndDate'])
          : null,
    );
  }
}
