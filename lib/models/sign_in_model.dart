class SignInModel {
  final String token;
  final String name;
  final String email;
  final String userId;
  final List<String> roles;
  final String? department;

  static SignInModel? currentUser;

  SignInModel({
    required this.token,
    required this.name,
    required this.email,
    required this.userId,
    required this.roles,
    this.department,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      token: json['token'],
      name: json['name'] ?? 'Student',
      email: json['email'],
      userId: json['userId'],
      roles: List<String>.from(json['roles'] ?? []),
      department: json['department'],
    );
  }
}
