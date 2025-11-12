class Booking {
  final String? bookingId;
  final int? serviceType;
  final String? title;
  final String? helperId;
  final String? helperName;
  final String? customerId;
  final String? description;
  final ServiceLocation? serviceLocation;
  final DateTime? scheduledStartTime;
  final DateTime? scheduledEndTime;
  final double? estimatedPrice;
  final String? customerNotes;
  final String? helperNotes;
  final bool? isRecurring;
  final String? recurringPattern;
  final int? status;
  final DateTime? recurringEndDate;

  Booking({
    this.helperName,
    this.bookingId,
    this.serviceType,
    this.helperId,
    this.customerId,
    this.helperNotes,
    this.title,
    this.description,
    this.serviceLocation,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.estimatedPrice,
    this.customerNotes,
    this.status,
    this.isRecurring,
    this.recurringPattern,
    this.recurringEndDate,
  });

  // Parse data from JSON into model
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      helperName: json['helperName'],
      serviceType: json['serviceType'],
      title: json['title'],
      helperId: json['helperId'],
      helperNotes: json['helperNotes'],
      customerId: json['customerId'],
      bookingId: json['id'],
      status: json['status'],
      description: json['description'],
      scheduledStartTime: DateTime.parse(json['scheduledStartTime']),
      scheduledEndTime: DateTime.parse(json['scheduledEndTime']),
      estimatedPrice: json['estimatedPrice'] != null
          ? (json['estimatedPrice'] as num).toDouble()
          : null,
      customerNotes: json['customerNotes'],
      isRecurring: json['isRecurring'],
      recurringPattern: json['recurringPattern'],
      recurringEndDate: json['recurringEndDate'] != null
          ? DateTime.parse(json['recurringEndDate'])
          : null,
      serviceLocation: json['serviceLocation'] != null
          ? ServiceLocation.fromJson(json['serviceLocation'])
          : null,
    );
  }
}

// ServiceLocation model of Booking model
class ServiceLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String district;
  final String ward;

  ServiceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.district,
    required this.ward,
  });

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    return ServiceLocation(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
    );
  }
}
