import 'package:tidybee_fe_app/features/helper/model/helper.dart';

class Booking {
  final String? id;
  final String? bookingRequestId;
  final String? helperId;
  final int? proposedPrice;
  final String? message;
  final DateTime? responseDate;
  final bool? isAccepted;
  final DateTime? createdAt;
  final Helper? helperInfo;

  Booking({
    this.id,
    this.bookingRequestId,
    this.helperId,
    this.proposedPrice,
    this.message,
    this.responseDate,
    this.isAccepted,
    this.createdAt,
    this.helperInfo,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString(),
      bookingRequestId: json['bookingRequestId']?.toString(),
      helperId: json['helperId']?.toString(),
      proposedPrice: _parseInt(json['proposedPrice']),
      message: json['message']?.toString(),
      responseDate: _parseDbDate(json['responseDate']),
      isAccepted: json['isAccepted'] as bool? ?? false,
      createdAt: _parseDbDate(json['createdAt']),
      helperInfo: json['helperInfo'] != null
          ? Helper.fromJson({'data': json['helperInfo']})
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bookingRequestId": bookingRequestId,
      "helperId": helperId,
      "proposedPrice": proposedPrice,
      "message": message,
      // Giữ nguyên giờ như DB, không tự convert timezone
      "responseDate": responseDate?.toIso8601String().replaceAll('Z', ''),
      "isAccepted": isAccepted,
      "createdAt": createdAt?.toIso8601String().replaceAll('Z', ''),
      if (helperInfo != null) "helperInfo": helperInfo!.toJson(),
    };
  }

  /// 🔹 Hàm parse thủ công, loại bỏ ký tự 'Z' để giữ nguyên giờ từ database
  static DateTime? _parseDbDate(dynamic value) {
    if (value == null) return null;
    try {
      String raw = value.toString();
      if (raw.endsWith('Z')) raw = raw.replaceAll('Z', '');
      final parsed = DateTime.parse(raw);
      return DateTime(
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
      );
    } catch (e) {
      return null;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

extension HelperJson on Helper {
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
      "workingHoursStart": workingHoursStart,
      "workingHoursEnd": workingHoursEnd,
      "workingDays": workingDays,
      "backgroundChecked": backgroundChecked,
      "documents": documents,
      "createdAt": createdAt?.toIso8601String().replaceAll('Z', ''),
      "helperName": helperName,
      "helperAvatar": helperAvatar,
    };
  }
}
