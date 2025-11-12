class EarningsStatisticsModel {
  final bool? success;
  final EarningsData? data;

  EarningsStatisticsModel({this.success, this.data});

  factory EarningsStatisticsModel.fromJson(Map<String, dynamic> json) {
    return EarningsStatisticsModel(
      success: json['success'] as bool?,
      data: json['data'] != null
          ? EarningsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, if (data != null) "data": data!.toJson()};
  }
}

class EarningsData {
  final String? helperId;
  final int? totalEarnings;
  final int? totalPlatformFees;
  final int? totalNetAmount;
  final int? paidOutAmount;
  final int? pendingAmount;
  final int? totalBookings;
  final int? completedBookings;
  final DateTime? lastEarning;
  final DateTime? lastPayout;

  EarningsData({
    this.helperId,
    this.totalEarnings,
    this.totalPlatformFees,
    this.totalNetAmount,
    this.paidOutAmount,
    this.pendingAmount,
    this.totalBookings,
    this.completedBookings,
    this.lastEarning,
    this.lastPayout,
  });

  factory EarningsData.fromJson(Map<String, dynamic> json) {
    return EarningsData(
      helperId: json['helperId']?.toString(),
      totalEarnings: _parseInt(json['totalEarnings']),
      totalPlatformFees: _parseInt(json['totalPlatformFees']),
      totalNetAmount: _parseInt(json['totalNetAmount']),
      paidOutAmount: _parseInt(json['paidOutAmount']),
      pendingAmount: _parseInt(json['pendingAmount']),
      totalBookings: _parseInt(json['totalBookings']),
      completedBookings: _parseInt(json['completedBookings']),
      lastEarning: json['lastEarning'] != null
          ? DateTime.tryParse(json['lastEarning'].toString())
          : null,
      lastPayout: json['lastPayout'] != null
          ? DateTime.tryParse(json['lastPayout'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "helperId": helperId,
      "totalEarnings": totalEarnings,
      "totalPlatformFees": totalPlatformFees,
      "totalNetAmount": totalNetAmount,
      "paidOutAmount": paidOutAmount,
      "pendingAmount": pendingAmount,
      "totalBookings": totalBookings,
      "completedBookings": completedBookings,
      "lastEarning": lastEarning?.toIso8601String(),
      "lastPayout": lastPayout?.toIso8601String(),
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
