class BookingRequest {
  final String? id;
  final String? title;
  final String? locationAddress;
  final DateTime? scheduledDate;
  final int? estimatedDuration;
  final int? budget;
  final List<String>? selectedHelperIds;
  final DateTime? createdAt;

  BookingRequest({
    this.id,
    this.title,
    this.locationAddress,
    this.scheduledDate,
    this.estimatedDuration,
    this.budget,
    this.selectedHelperIds,
    this.createdAt,
  });

  factory BookingRequest.fromJson(Map<String, dynamic> json) {
    return BookingRequest(
      id: json['id'],
      title: json['title'],
      locationAddress: json['locationAddress'],
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : null,
      estimatedDuration: json['estimatedDuration'],
      budget: json['budget'],
      selectedHelperIds: List<String>.from(json['selectedHelperIds'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }
}
