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
      responseDate: _parseExactDate(json['responseDate']),
      isAccepted: json['isAccepted'] as bool? ?? false,
      createdAt: _parseExactDate(json['createdAt']),
      helperInfo: json['helperInfo'] != null
          ? Helper.fromJson(json['helperInfo'])
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
      "responseDate": responseDate != null ? _formatDate(responseDate!) : null,
      "isAccepted": isAccepted,
      "createdAt": createdAt != null ? _formatDate(createdAt!) : null,
      if (helperInfo != null) "helperInfo": helperInfo!.toJson(),
    };
  }

  static DateTime? _parseExactDate(dynamic value) {
    if (value == null) return null;
    try {
      String raw = value.toString().replaceAll('Z', '');

      final parts = raw.split('T');
      final dateParts = parts[0].split('-');
      final timeParts = parts.length > 1
          ? parts[1].split(':')
          : ['0', '0', '0'];

      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
        int.parse(timeParts[2].split('.')[0]),
      );
    } catch (e) {
      return null;
    }
  }

  static String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}T"
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}:"
        "${date.second.toString().padLeft(2, '0')}";
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
      "createdAt": createdAt != null ? Booking._formatDate(createdAt!) : null,
      "helperName": helperName,
      "helperAvatar": helperAvatar,
    };
  }
}
