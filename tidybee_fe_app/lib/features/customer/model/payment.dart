class Payment {
  String? id;
  String? bookingRequestId;
  String? customerId;
  String? helperId;
  String? transactionId;
  double? amount;
  double? platformFee;
  double? helperAmount;
  String? helperName;
  String? customerName;
  int? paymentMethod;
  int? status;
  String? description;
  bool? isEscrowed;
  DateTime? escrowReleaseDate;
  DateTime? processedAt;
  DateTime? completedAt;
  bool? isRefunded;
  double? refundAmount;
  DateTime? createdAt;

  Payment({
    this.id,
    this.bookingRequestId,
    this.customerId,
    this.helperId,
    this.transactionId,
    this.amount,
    this.platformFee,
    this.helperAmount,
    this.paymentMethod,
    this.status,
    this.description,
    this.isEscrowed,
    this.escrowReleaseDate,
    this.processedAt,
    this.completedAt,
    this.isRefunded,
    this.refundAmount,
    this.createdAt,
    this.customerName,
    this.helperName,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      bookingRequestId: json['bookingRequestId'],
      customerId: json['customerId'],
      helperId: json['helperId'],
      customerName: json['customerName'],
      helperName: json['helperName'],
      transactionId: json['transactionId'],
      amount: (json['amount'] ?? 0).toDouble(),
      platformFee: (json['platformFee'] ?? 0).toDouble(),
      helperAmount: (json['helperAmount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      description: json['description'],
      isEscrowed: json['isEscrowed'],
      escrowReleaseDate: json['escrowReleaseDate'] != null
          ? DateTime.parse(json['escrowReleaseDate'])
          : null,
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      isRefunded: json['isRefunded'],
      refundAmount: json['refundAmount'] != null
          ? (json['refundAmount'] as num).toDouble()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
