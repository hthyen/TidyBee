class QrPayment {
  String? qrCodeUrl;
  String? orderCode;
  double? amount;
  String? bankAccount;
  String? bankCode;
  String? accountHolderName;
  String? paymentDescription;

  QrPayment({
    this.qrCodeUrl,
    this.orderCode,
    this.amount,
    this.bankAccount,
    this.bankCode,
    this.accountHolderName,
    this.paymentDescription,
  });

  factory QrPayment.fromJson(Map<String, dynamic> json) {
    return QrPayment(
      qrCodeUrl: json['qrCodeUrl'],
      orderCode: json['orderCode'],
      amount: (json['amount'] != null)
          ? (json['amount'] as num).toDouble()
          : null,
      bankAccount: json['bankAccount'],
      bankCode: json['bankCode'],
      accountHolderName: json['accountHolderName'],
      paymentDescription: json['paymentDescription'],
    );
  }
}
