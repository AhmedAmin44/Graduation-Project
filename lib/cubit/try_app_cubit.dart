// cubit/application_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:graduation_app/models/try_app_model.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  final Dio dio;

  ApplicationCubit({required this.dio}) : super(ApplicationInitial());

  Future<void> fetchApplicationDetails(int applicationId, String token) async {
    emit(ApplicationLoading());
    try {
      final response = await dio.get(
        'https://nextstep.runasp.net/api/Applications/$applicationId/details',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final applicationDetails = ApplicationDetails.fromJson(response.data);
      emit(ApplicationLoaded(applicationDetails: applicationDetails));
    } on DioException catch (e) {
      emit(ApplicationError(message: e.response?.data['message'] ?? 'Failed to load application details'));
    } catch (e) {
      emit(ApplicationError(message: 'An unexpected error occurred'));
    }
  }
}

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationLoaded extends ApplicationState {
  final ApplicationDetails applicationDetails;

  const ApplicationLoaded({required this.applicationDetails});

  @override
  List<Object> get props => [applicationDetails];
}

class ApplicationError extends ApplicationState {
  final String message;

  const ApplicationError({required this.message});

  @override
  List<Object> get props => [message];
}