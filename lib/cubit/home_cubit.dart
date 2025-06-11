import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/api/api_consumer.dart';
import 'package:graduation_app/cubit/home_states.dart';
import 'package:graduation_app/models/application_model.dart';
import 'package:graduation_app/models/student_application.dart';
import 'package:graduation_app/repositories/application_details_repository.dart';


class HomeCubit extends Cubit<HomeState> {
  final ApiConsumer api;
  final ApplicationRepository _repository;

  HomeCubit(this._repository, {required this.api}) : super(HomeInitial());

  Future<void> fetchStudentApplications(String token) async {
    emit(HomeLoading());
    try {
      final response = await api.get(
        '/Applications/GetAppsForStudent',
        headers: {'Authorization': 'Bearer $token'},
      );
      print("API Response: $response"); 
      
      final applications = (response as List)
          .map((data) => StudentApplication.fromJson(data))
          .toList();
      emit(HomeLoaded(applications: applications));
    } catch (e) {
      print("API Error: $e"); // Debugging log
      emit(HomeError(message: 'Failed to load applications.'));
    }
  }

  Future<void> getApplicationStatus(int applicationId,String token) async {
    emit(ApplicationStatusLoading());
    try {
      final response = await api.get(
        '/Applications/14/details',
        headers: {'Authorization': 'Bearer $token'},
      );
      print("API Response: $response"); 
      
      final status = (response as List)
          .map((data) => ApplicationStatus.fromJson(data))
          .toString();
      emit(ApplicationStatusTextLoaded(status));
    } catch (e) {
      print("API Error: $e"); // Debugging log
      emit(ApplicationStatusError('Failed to load application status.'));
    }
  }

  Future<void> getApplicationSteps(int applicationId) async {
    emit(ApplicationStepsLoading());
    
    final Either<String, List<ApplicationStep>> result = 
        await _repository.getApplicationSteps(applicationId.toString());

    result.fold(
      (error) => emit(ApplicationStepsError(error)),
      (steps) => emit(ApplicationStepsLoaded(steps)),
    );
  }

  Future<void> getApplicationStatusText(int applicationId) async {
    emit(ApplicationStatusTextLoading());
    
    final Either<String, String> result = 
        await _repository.getApplicationStatusText(applicationId.toString());

    result.fold(
      (error) => emit(ApplicationStatusTextError(error)),
      (statusText) => emit(ApplicationStatusTextLoaded(statusText)),
    );
  }
}