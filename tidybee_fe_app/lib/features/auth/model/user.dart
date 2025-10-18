class User {
  final String? id;
  final String? firstName;
  final String? password;
  final String? accessToken;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? role;
  final int? status;
  final DateTime? lastLoginAt;
  final String? avatar;
  final DateTime? dateOfBirth;
  final String? gender;
  final DateTime? createdAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.password,
    this.accessToken,
    this.email,
    this.phoneNumber,
    this.role,
    this.status,
    this.lastLoginAt,
    this.avatar,
    this.dateOfBirth,
    this.gender,
    this.createdAt,
  });

  // Parse data from JSON into model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      accessToken: json["accessToken"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      role: json["role"],
      status: json["status"],
      lastLoginAt: json["lastLoginAt"] != null
          ? DateTime.tryParse(json["lastLoginAt"])
          : null,
      avatar: json["avatar"],
      dateOfBirth: json["dateOfBirth"] != null
          ? DateTime.tryParse(json["dateOfBirth"])
          : null,
      gender: json["gender"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
