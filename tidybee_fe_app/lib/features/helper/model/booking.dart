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
      responseDate: json['responseDate'] != null
          ? DateTime.tryParse(json['responseDate'].toString())
          : null,
      isAccepted: json['isAccepted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
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
      "responseDate": responseDate?.toIso8601String(),
      "isAccepted": isAccepted,
      "createdAt": createdAt?.toIso8601String(),
      if (helperInfo != null) "helperInfo": helperInfo!.toJson(),
    };
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
      "createdAt": createdAt?.toIso8601String(),
      "helperName": helperName,
      "helperAvatar": helperAvatar,
    };
  }
}
