// class SignupResponse {
//   final String? status;
//   final String? message;
//   final SignupUser? user;

//   SignupResponse({
//     this.status,
//     this.message,
//     this.user,
//   });

//   factory SignupResponse.fromJson(Map<String, dynamic> json) {
//     return SignupResponse(
//       status: json["status"] as String?,
//       message: json["message"] as String?,
//       user: json["user"] != null
//           ? SignupUser.fromJson(json["user"])
//           : null,
//     );
//   }
// }

// class RegisterResponse {
//   final bool? status;
//   final String? message;
//   final User? user;
//   final Map<String, List<String>>? errors;

//   RegisterResponse({
//     this.status,
//     this.message,
//     this.user,
//     this.errors,
//   });

//   factory RegisterResponse.fromJson(Map<String, dynamic> json) {
//     return RegisterResponse(
//       status: json['status'],
//       message: json['message'],
//       user: json['user'] != null ? User.fromJson(json['user']) : null,

//       // Parse errors: { "email": ["already taken"] }
//       errors: json['errors'] != null
//           ? Map<String, List<String>>.from(
//               json['errors'].map(
//                 (key, value) => MapEntry(
//                   key.toString(),
//                   List<String>.from(value.map((e) => e.toString())),
//                 ),
//               ),
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "status": status,
//       "message": message,
//       "user": user?.toJson(),
//       "errors": errors,
//     };
//   }
// }


class SignupResponse {
  final bool? status;
  final String? message;
  final SignupUser? user;
  final Map<String, List<String>>? errors;

  SignupResponse({
    this.status,
    this.message,
    this.user,
    this.errors,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      status: json['status'] is bool
          ? json['status']
          : json['status'].toString().toLowerCase() == "true",

      message: json['message'],

      user: json['user'] != null
          ? SignupUser.fromJson(json['user'])
          : null,

      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              json['errors'].map(
                (key, value) => MapEntry(
                  key.toString(),
                  List<String>.from(value.map((e) => e.toString())),
                ),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "user": user?.toJson(),
      "errors": errors,
    };
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
      name: json["name"],
      email: json["email"],
      role: json["role"],
      phone: json["phone"],
      updatedAt: json["updated_at"],
      createdAt: json["created_at"],
      id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "role": role,
      "phone": phone,
      "updated_at": updatedAt,
      "created_at": createdAt,
      "id": id,
    };
  }
}
