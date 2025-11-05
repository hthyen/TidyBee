class PayoutRequestModel {
  final List<String>? earningIds;
  final String? payoutMethod;
  final String? notes;

  PayoutRequestModel({
    required this.earningIds,
    required this.payoutMethod,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "earningIds": earningIds,
      "payoutMethod": payoutMethod,
      "notes": notes,
    };
  }
}

class PayoutResponseModel {
  final bool? success;
  final String? message;
  final PayoutData? data;

  PayoutResponseModel({this.success, this.message, this.data});

  factory PayoutResponseModel.fromJson(Map<String, dynamic> json) {
    return PayoutResponseModel(
      success: json['success'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] != null
          ? PayoutData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PayoutData {
  final String? payoutTransactionId;
  final int? totalAmount;
  final int? earningsCount;
  final List<String>? helperIds;

  PayoutData({
    this.payoutTransactionId,
    this.totalAmount,
    this.earningsCount,
    this.helperIds,
  });

  factory PayoutData.fromJson(Map<String, dynamic> json) {
    return PayoutData(
      payoutTransactionId: json['payoutTransactionId']?.toString(),
      totalAmount: _parseInt(json['totalAmount']),
      earningsCount: _parseInt(json['earningsCount']),
      helperIds: json['helperIds'] != null
          ? List<String>.from(json['helperIds'].map((x) => x?.toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "payoutTransactionId": payoutTransactionId,
      "totalAmount": totalAmount,
      "earningsCount": earningsCount,
      "helperIds": helperIds,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
