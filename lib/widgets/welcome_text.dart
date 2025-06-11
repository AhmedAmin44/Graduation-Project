import 'package:flutter/cupertino.dart';
import 'package:graduation_app/core/utils/app_text_style.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.07;

    return Align(
      alignment: Alignment.center,
      child: Text(
        text,
        style: CustomTextStyles.poppins600style28.copyWith(fontSize: fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}
