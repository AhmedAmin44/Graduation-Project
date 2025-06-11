import 'package:flutter/cupertino.dart';
import 'package:graduation_app/core/utils/app_colors.dart';


class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: AppColors.prColor,
      height: 270,
      width: 375,
      child: Image.asset(
        'assets/images/sign_In_image.png',
        fit: BoxFit.cover,
      ),
    );
  }
}