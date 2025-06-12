import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graduation_app/cache/cache_helper.dart';
import 'package:graduation_app/core/utils/app_text_style.dart';
import 'package:graduation_app/core/widgets/customButton.dart';
import 'package:graduation_app/models/on_boaarding_model.dart';
import 'package:graduation_app/screens/sign_in_screen.dart';
import 'package:graduation_app/widgets/on_boarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffB02672),
                Color.fromARGB(255, 224, 136, 184).withOpacity(0.1),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(height: screenHeight * 0.03),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      OnBoardingVisited();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Skip',
                        style: CustomTextStyles.poppins300style16
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                OnBordingBody(
                  controller: _controller,
                  OnPageChanged: (index) {
                    currentIndex = index;
                    setState(() {});
                  },
                ),
                SizedBox(height: screenHeight * 0.2),
                currentIndex == onBoardingData.length - 1
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              OnBoardingVisited();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color:  Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xffB02672),
                                    blurRadius: 15,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: CustomTextStyles.poppins300style16
                                      .copyWith(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : CustomBotton(
                        text: 'Next',
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceIn,
                          );
                        },
                      ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void OnBoardingVisited() {
  getIt<CacheHelper>().saveData(key: "isOnboardingVisited", value: true);
  var result = getIt<CacheHelper>().getData(key: "isOnboardingVisited");
  print("🚀 isOnboardingVisited : $result");
}

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<CacheHelper>(CacheHelper());
}
