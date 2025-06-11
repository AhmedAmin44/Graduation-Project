import 'package:dio/dio.dart';
import 'package:graduation_app/models/user_profile_model.dart';

class UserProfileRepository {
  final Dio _dio;

  UserProfileRepository([Dio? dio]) : _dio = dio ?? Dio();

  Future<UserProfileModel> fetchUserProfile() async {
    final response = await 
    _dio.get('https://nextstep.runasp.net/api/Auth/login-student');
    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
