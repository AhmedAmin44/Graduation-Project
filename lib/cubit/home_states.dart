import 'package:equatable/equatable.dart';
import 'package:graduation_app/models/student_application.dart';
import 'package:graduation_app/models/application_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

// Home States
class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<StudentApplication> applications;
  const HomeLoaded({required this.applications});
  @override
  List<Object> get props => [applications];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object> get props => [message];
}


// Application Status States

class ApplicationStatusInitial extends HomeState {}

class ApplicationStatusLoading extends HomeState {}

class ApplicationStatusLoaded extends HomeState {
  final ApplicationStatus status;
  const ApplicationStatusLoaded(this.status);
  @override
  List<Object> get props => [status];
}

class ApplicationStatusError extends HomeState {
  final String message;
  const ApplicationStatusError(this.message);
  @override
  List<Object> get props => [message];
}


// Application Steps States

class ApplicationStepsLoading extends HomeState {}

class ApplicationStepsLoaded extends HomeState {
  final List<ApplicationStep> steps;
  const ApplicationStepsLoaded(this.steps);
  @override
  List<Object> get props => [steps];
}

class ApplicationStepsError extends HomeState {
  final String message;
  const ApplicationStepsError(this.message);
  @override
  List<Object> get props => [message];
}


// Application Status Text States

class ApplicationStatusTextLoading extends HomeState {}

class ApplicationStatusTextLoaded extends HomeState {
  final String statusText;
  const ApplicationStatusTextLoaded(this.statusText);
  @override
  List<Object> get props => [statusText];
}

class ApplicationStatusTextError extends HomeState {
  final String message;
  const ApplicationStatusTextError(this.message);
  @override
  List<Object> get props => [message];
}
