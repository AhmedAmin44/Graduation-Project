import 'package:flutter/cupertino.dart';
import 'package:graduation_app/core/utils/app_colors.dart';
import 'package:graduation_app/core/utils/app_text_style.dart';
import 'package:graduation_app/models/on_boaarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBordingBody extends StatelessWidget {
  const OnBordingBody({
    Key? key,
    required this.controller,
    required this.OnPageChanged,
  }) : super(key: key);
  final PageController controller;
  final Function(int) OnPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: PageView.builder(
        onPageChanged: OnPageChanged,
        physics: const BouncingScrollPhysics(),
        controller: controller,
        itemCount: onBoardingData.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Container(
                  height: 275,
                  width: 343,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(onBoardingData[index].imagePath),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomSmoothPageIndicator(controller: controller),
                const SizedBox(height: 32),
                Text(
                  onBoardingData[index].title,
                  style: CustomTextStyles.poppins500style24.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    onBoardingData[index].subTitle,
                    style: CustomTextStyles.poppins300style16,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({Key? key, required this.controller})
    : super(key: key);
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColors.prColor,
        dotHeight: 6,
        dotWidth: 10,
      ),
    );
  }
}
