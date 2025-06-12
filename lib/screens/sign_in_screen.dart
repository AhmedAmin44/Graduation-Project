import 'package:flutter/material.dart%20%20';
import 'package:graduation_app/core/utils/app_string.dart';
import 'package:graduation_app/widgets/banner_login.dart';
import 'package:graduation_app/widgets/custom_signin.dart';
import 'package:graduation_app/widgets/welcome_text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: WelcomeBanner(),),
            SliverToBoxAdapter(child: SizedBox(height: 32), ),
            SliverToBoxAdapter(child: WelcomeWidget(text: AppStrings.welcomeBack),),
            SliverToBoxAdapter( child: SizedBox(height: 80),),
            SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomSignInForm(), ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20),),
          ],
        ),
      ),
    );
  }
}

