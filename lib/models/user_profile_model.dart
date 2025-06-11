class UserProfileModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String? department;
  final String loggedId;

  UserProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.loggedId,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      department: json['department'] as String?,
      loggedId: json['loggedId'].toString(),
    );
  }
}
