import 'package:dartz/dartz.dart';
import 'package:graduation_app/core/api/api_consumer.dart';
import 'package:graduation_app/core/api/end_ponits.dart';
import 'package:graduation_app/core/errors/exceptions.dart';
import 'package:graduation_app/models/application_model.dart';

class ApplicationRepository {
  final ApiConsumer api;

  ApplicationRepository({required this.api});

  Future<Either<String, ApplicationStatus>> getApplicationStatus(
      String applicationId) async {
    try {
      final response = await api.get(
        EndPoint.applicationDetailsAndStatus(applicationId as int), headers: {},
      );
      return Right(ApplicationStatus.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, List<ApplicationStep>>> getApplicationSteps(
      String applicationId) async {
    try {
      final response = await api.get(
        EndPoint.applicationDetailsAndStatus(applicationId as int), headers: {},
      );
      final status = ApplicationStatus.fromJson(response);
      return Right(status.steps);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }

  Future<Either<String, String>> getApplicationStatusText(
      String applicationId) async {
    try {
      final response = await api.get(
        EndPoint.applicationDetailsAndStatus(applicationId as int), headers: {},
      );
      final status = ApplicationStatus.fromJson(response);
      return Right(status.status);
    } on ServerException catch (e) {
      return Left(e.errModel.errorMessage);
    }
  }
}