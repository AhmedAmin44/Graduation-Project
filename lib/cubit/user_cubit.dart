import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/user_state.dart';
import 'package:graduation_app/repositories/user_repository.dart';


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
      (errMessage) => emit(SignInFailure(errMessage: errMessage)),
      (signInModel) => emit(SignInSuccess(signInModel: signInModel)),
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