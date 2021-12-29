class User {
  final List<String> warehouses;
  final String role;

  final String profileImage;

  final bool blocked;

  final String id;

  final String name;

  final String email;

  final String resetPasswordToken;

  User({
    required this.warehouses,
    required this.role,
    required this.profileImage,
    required this.blocked,
    required this.id,
    required this.name,
    required this.email,
    required this.resetPasswordToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        warehouses: List.from(json["warehouses"]),
        role: json["role"],
        profileImage: json["profile_image"],
        blocked: json["blocked"],
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        resetPasswordToken: json["resetPasswordToken"],
      );
}
