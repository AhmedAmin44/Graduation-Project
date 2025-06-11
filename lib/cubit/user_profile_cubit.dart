import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/models/user_profile_model.dart';
import 'package:graduation_app/repositories/user_profile_repository.dart';

abstract class UserProfileState {}
class UserInitial extends UserProfileState {}
class UserLoading extends UserProfileState {}
class UserLoaded extends UserProfileState {
  final UserProfileModel user;
  UserLoaded(this.user);
}
class UserError extends UserProfileState {
  final String message;
  UserError(this.message);
}

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileRepository _repo;
  UserProfileCubit(this._repo) : super(UserInitial());

  Future<void> fetchUser() async {
    try {
      emit(UserLoading());
      final user = await _repo.fetchUserProfile();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
