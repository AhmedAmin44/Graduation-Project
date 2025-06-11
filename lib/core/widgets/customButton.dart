// ignore_for_file: file_names

import 'package:flutter/material.dart%20%20';
import 'package:graduation_app/core/utils/app_colors.dart';
import 'package:graduation_app/core/utils/app_text_style.dart';

class CustomBotton extends StatelessWidget {
  const CustomBotton(
      {super.key, this.color, required this.text, required this.onPressed});
  final Color? color;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Color(0xffB02672),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(
            text,
            style: CustomTextStyles.poppins500style24
                .copyWith(fontSize: 18, color: AppColors.offWhite),
          )),
    );
  }
}
