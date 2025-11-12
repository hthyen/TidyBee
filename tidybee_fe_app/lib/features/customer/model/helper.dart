// Helper model
class Helper {
  String? helperId;
  int? serviceType;
  double? pricePerHour;
  double? rating;
  int? totalRatings;
  bool? isAvailable;
  String? helperName;
  Location? location;

  Helper({
    this.helperId,
    this.serviceType,
    this.pricePerHour,
    this.rating,
    this.totalRatings,
    this.isAvailable,
    this.helperName,
    this.location,
  });

  // Parse data from json into model
  factory Helper.fromJson(Map<String, dynamic> json) {
    return Helper(
      helperId: json['helperId'],
      serviceType: json['serviceType'],
      pricePerHour: (json['pricePerHour'] != null)
          ? (json['pricePerHour']).toDouble()
          : null,
      rating: (json['rating'] != null) ? (json['rating']).toDouble() : null,
      totalRatings: json['totalRatings'],
      isAvailable: json['isAvailable'],
      helperName: json['helperName'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }
}

// Location model
class Location {
  double? latitude;
  double? longitude;
  String? address;
  String? city;
  String? district;
  String? ward;

  Location({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.district,
    this.ward,
  });

  // Parse data from json into model
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] != null)
          ? (json['latitude']).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude']).toDouble()
          : null,
      address: json['address'],
      city: json['city'],
      district: json['district'],
      ward: json['ward'],
    );
  }
}
