import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/functions/custom_troast.dart';
import 'package:graduation_app/core/widgets/customButton.dart';
import 'package:graduation_app/cubit/user_cubit.dart';
import 'package:graduation_app/cubit/user_state.dart';
import 'package:graduation_app/screens/home_screen.dart';
import 'package:graduation_app/widgets/text_form_field.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CustomSignInForm extends StatelessWidget {
  const CustomSignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is SignInFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMessage)),
          );
        } else if (state is SignInSuccess) {
          final decodedToken = JwtDecoder.decode(state.signInModel.token);
          
          // Extract 'sub' field or fallback to 'Student'
          final studentName = decodedToken['sub'] ?? 'Student';

          ShowToast('Sign In Successful');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(
                token: state.signInModel.token,
                studentName: studentName,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UserCubit>();
        
        return Form(
          key: cubit.signInFormKey,
          child: Column(
            children: [
              TextFField(
                labelText: 'Enter Your National ID',
                obscureText: cubit.obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    cubit.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: cubit.togglePasswordVisibility,
                ),
                controller: cubit.nIdPasswordController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Natioal ID is required';
                  }
                  if (value.length != 14) {
                    return 'National ID must be 14 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Only numbers are allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 190),
              cubit.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.purple,
                     
                  )
                  : CustomBotton(
                      onPressed: cubit.signIn,
                      text: 'Sign In',
                    ),
            ],
          ),
        );
      },
    );
  }
}