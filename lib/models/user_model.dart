import 'package:graduation_app/core/api/end_ponits.dart';

class UserModel {
  final String name;
  UserModel({
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      name: jsonData['user'][ApiKey.name],
    );
  }
}
