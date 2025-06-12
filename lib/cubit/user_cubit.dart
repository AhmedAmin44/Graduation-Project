import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cache/cache_helper.dart';
import 'package:graduation_app/cubit/user_state.dart';
import 'package:graduation_app/repositories/user_repository.dart';
import 'package:graduation_app/screens/on_boarding_screen.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(UserInitial());
  final UserRepository userRepository;

  // Form key
  final GlobalKey<FormState> signInFormKey = GlobalKey();

  // Controllers
  final TextEditingController nIdPasswordController = TextEditingController();

  // State variables
  bool obscurePassword = true;
  bool isLoading = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(PasswordVisibilityChanged());
  }

  // Sign in method
  Future<void> signIn() async {
    if (!signInFormKey.currentState!.validate()) return;

    isLoading = true;
    emit(SignInLoading());

    final response = await userRepository.signIn(
      nIdPassowrd: nIdPasswordController.text,
    );

    response.fold(
      (errMessage) {
        isLoading = false;
        emit(SignInFailure(errMessage: errMessage));
      },
      (signInModel) async {
        await getIt<CacheHelper>().saveData(
          key: "token",
          value: signInModel.token,
        );
        await getIt<CacheHelper>().saveData(
          key: "isOnboardingVisited",
          value: true,
        );

        emit(SignInSuccess(signInModel: signInModel));
      },
    );

    isLoading = false;
  }

  // Get user data
  // Future<void> getUserdata() async {
  //   emit(GetUserLoading());
  //   final response = await userRepository.getUserProfile();
  //   response.fold(
  //     (errMessage) => emit(GetUserFailure(errMessage: errMessage)),
  //     (user) => emit(GetUserSuccess(user: user)),
  //   );
  // }
}
