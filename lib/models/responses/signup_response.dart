class SignupResponse {
  final String? status;
  final String? message;
  final SignupUser? user;

  SignupResponse({
    this.status,
    this.message,
    this.user,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      status: json["status"] as String?,
      message: json["message"] as String?,
      user: json["user"] != null
          ? SignupUser.fromJson(json["user"])
          : null,
    );
  }
}


class SignupUser {
  final String? name;
  final String? email;
  final String? role;
  final String? phone;
  final String? updatedAt;
  final String? createdAt;
  final int? id;

  SignupUser({
    this.name,
    this.email,
    this.role,
    this.phone,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory SignupUser.fromJson(Map<String, dynamic> json) {
    return SignupUser(
      name: json["name"] as String?,
      email: json["email"] as String?,
      role: json["role"] as String?,
      phone: json["phone"] as String?,
      updatedAt: json["updated_at"] as String?,
      createdAt: json["created_at"] as String?,
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    );
  }
}
