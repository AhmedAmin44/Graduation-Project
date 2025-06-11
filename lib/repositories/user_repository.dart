
import 'package:dartz/dartz.dart';
import 'package:graduation_app/cache/cache_helper.dart';
import 'package:graduation_app/core/api/api_consumer.dart';
import 'package:graduation_app/core/api/end_ponits.dart';
import 'package:graduation_app/core/errors/exceptions.dart';
import 'package:graduation_app/models/sign_in_model.dart';
import 'package:graduation_app/models/student_application.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserRepository {
  final ApiConsumer api;

  UserRepository({required this.api});
  Future<Either<String, SignInModel>> signIn({
    required String nIdPassowrd,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signIn,
        data: {
          ApiKey.nIdPassowrd: nIdPassowrd,
        },
      );

      final user = SignInModel.fromJson(response);
          SignInModel.currentUser = user;

      final decodedToken = JwtDecoder.decode(user.token);
      CacheHelper().saveData(key: ApiKey.token, value: user.token);
      CacheHelper().saveData(key: ApiKey.id, value: decodedToken[ApiKey.id]);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, StudentApplication>> getUserProfile() async {
    try {
      final response = await api.get(
        
        
        EndPoint.getUserDataEndPoint(
          CacheHelper().getData(key: ApiKey.id),
        ), headers: {

        },
      );
      return Right(StudentApplication.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}
