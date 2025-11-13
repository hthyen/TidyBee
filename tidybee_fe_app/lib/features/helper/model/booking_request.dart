import 'package:flutter/material.dart';

class BookingRequest {
  final String? id;
  final String? customerId;
  final String? helperId;
  final String? helperName;
  final int? serviceType;
  final String? title;
  final String? description;
  final ServiceLocation? serviceLocation;
  final DateTime? scheduledStartTime;
  final DateTime? scheduledEndTime;
  final int? estimatedPrice;
  final int? finalPrice;
  final int? status;
  final String? customerNotes;
  final String? helperNotes;
  final bool? isRecurring;
  final String? recurringPattern;
  final DateTime? recurringEndDate;
  final List<String>? selectedHelperIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BookingRequest({
    this.id,
    this.customerId,
    this.helperId,
    this.helperName,
    this.serviceType,
    this.title,
    this.description,
    this.serviceLocation,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.estimatedPrice,
    this.finalPrice,
    this.status,
    this.customerNotes,
    this.helperNotes,
    this.isRecurring,
    this.recurringPattern,
    this.recurringEndDate,
    this.selectedHelperIds,
    this.createdAt,
    this.updatedAt,
  });

  // ---------------- GETTERS cho UI ----------------
  String? get locationAddress => serviceLocation?.address;

  DateTime? get scheduledDate => scheduledStartTime;

  int? get estimatedDuration {
    if (scheduledStartTime == null || scheduledEndTime == null) return null;
    return scheduledEndTime!.difference(scheduledStartTime!).inHours;
  }

  int? get budget => estimatedPrice;

  String get statusText {
    switch (status) {
      case 1:
        return "Mới tạo";
      case 2:
        return "Đang tìm helper";
      case 3:
        return "Đã giao";
      case 4:
        return "Đang thực hiện";
      case 5:
        return "Hoàn thành";
      case 6:
        return "Đã hủy";
      default:
        return "Không rõ";
    }
  }

  Color get statusColor {
    switch (status) {
      case 3:
        return Colors.orange;
      case 4:
        return Colors.blue;
      case 5:
        return Colors.green;
      case 6:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ---------------- FROM JSON ----------------
  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    print('📥 [BookingRequest] Raw JSON: $json');

    return BookingRequest(
      id: json['id']?.toString(),
      customerId: json['customerId']?.toString(),
      helperId: json['helperId']?.toString(),
      helperName: json['helperName']?.toString(),
      serviceType: _parseInt(json['serviceType']),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      serviceLocation: json['serviceLocation'] != null
          ? ServiceLocation.fromJson(json['serviceLocation'])
          : null,
      scheduledStartTime: _parseDbDate(json['scheduledStartTime']),
      scheduledEndTime: _parseDbDate(json['scheduledEndTime']),
      estimatedPrice: _parseInt(json['estimatedPrice']),
      finalPrice: _parseInt(json['finalPrice']),
      status: _parseInt(json['status']),
      customerNotes: json['customerNotes']?.toString(),
      helperNotes: json['helperNotes']?.toString(),
      isRecurring: json['isRecurring'] as bool?,
      recurringPattern: json['recurringPattern']?.toString(),
      recurringEndDate: _parseDbDate(json['recurringEndDate']),
      selectedHelperIds:
          (json['selectedHelperIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: _parseDbDate(json['createdAt']),
      updatedAt: _parseDbDate(json['updatedAt']),
    );
  }

  // ---------------- TO JSON ----------------
  Map<String, dynamic> toJson() {
    final data = {
      "id": id,
      "customerId": customerId,
      "helperId": helperId,
      "helperName": helperName,
      "serviceType": serviceType,
      "title": title,
      "description": description,
      "serviceLocation": serviceLocation?.toJson(),
      "scheduledStartTime": scheduledStartTime?.toIso8601String(),
      "scheduledEndTime": scheduledEndTime?.toIso8601String(),
      "estimatedPrice": estimatedPrice,
      "finalPrice": finalPrice,
      "status": status,
      "customerNotes": customerNotes,
      "helperNotes": helperNotes,
      "isRecurring": isRecurring,
      "recurringPattern": recurringPattern,
      "recurringEndDate": recurringEndDate?.toIso8601String(),
      "selectedHelperIds": selectedHelperIds,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };

    print('📤 [BookingRequest] toJson: $data');
    return data;
  }

  // ---------------- UTILITIES ----------------
  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static DateTime? _parseDbDate(dynamic v) {
    if (v == null) return null;

    try {
      final raw = v.toString();
      print('⏱️ Raw DB datetime: $raw');
      final clean = raw.replaceAll('Z', '');
      final parsed = DateTime.parse(clean);

      print('✅ Parsed (giữ nguyên DB): $parsed');
      return parsed;
    } catch (e) {
      print('❌ Lỗi parse datetime: $e | raw: $v');
      return null;
    }
  }
}

// ---------------- ServiceLocation ----------------
class ServiceLocation {
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? city;
  final String? district;
  final String? ward;

  ServiceLocation({
    this.latitude,
    this.longitude,
    this.address,
    this.city,
    this.district,
    this.ward,
  });

  factory ServiceLocation.fromJson(Map<String, dynamic> json) {
    return ServiceLocation(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      ward: json['ward']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'city': city,
    'district': district,
    'ward': ward,
  };
}
